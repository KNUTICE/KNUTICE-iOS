//
//  SearchCollectionViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import CorePresentation
import Factory
import KNDomain
import RxRelay
import RxSwift
import os

@MainActor
public final class SearchViewModel: NoticeSectionModelProvidable {
    public let notices: BehaviorRelay<[NoticeSectionModel]> = .init(value: [])
    let bookmarks: BehaviorRelay<[Bookmark]> = .init(value: [])
    let keyword: BehaviorRelay<String> = .init(value: "")
    
    @Injected(\.searchNoticesUseCase) private var searchNoticesUseCase
    @Injected(\.searchBookmarksUseCase) private var searchBookmarksUseCase
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let logger: Logger = Logger()
    private var initialTask: Task<Void, Never>?
    private(set) var nextNoticesPageTask: Task<Void, Never>?
    private var hasNextNoticesPage = true
    
    func search(with keyword: String) {
        guard !keyword.isEmpty else {
            notices.accept([])
            bookmarks.accept([])
            hasNextNoticesPage = false
            return
        }
        
        hasNextNoticesPage = true
        initialTask?.cancel()
        initialTask = Task {
            async let noticesResult = searchNoticesUseCase.execute(with: keyword)
            async let bookmarksResult = searchBookmarksUseCase.execute(with: keyword)
            
            do {
                let (notices, bookmarks) = try await (noticesResult, bookmarksResult)
                let noticeSectionModel = NoticeSectionModel(items: notices)
                self.notices.accept([noticeSectionModel])
                self.bookmarks.accept(bookmarks)
            } catch {
                logger.error("SearchViewModel: \(error)")
            }
        }
    }
    
    func fetchNextNoticesPage() {
        guard hasNextNoticesPage, let lastId = notices.value.last?.items.last?.id else { return }
        
        nextNoticesPageTask?.cancel()
        nextNoticesPageTask = Task {
            do {
                let notices = try await searchNoticesUseCase.execute(with: keyword.value, after: lastId)
                
                guard !notices.isEmpty else {
                    self.hasNextNoticesPage = false
                    return
                }
                
                guard var current = self.notices.value.first else { return }
                
                current.items.append(contentsOf: notices)
                self.notices.accept([current])
            } catch {
                logger.error("SearchViewModel: \(error)")
            }
        }
    }
    
}
