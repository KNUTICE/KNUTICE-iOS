//
//  BookmarkTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore
import RxRelay
import RxSwift
import os

@MainActor
final class BookmarkTableViewModel: BookmarkSortOptionProvidable {
    let bookmarks: BehaviorRelay<[BookmarkSectionModel]> = .init(value: [])
    let isRefreshing: BehaviorRelay<Bool> = .init(value: false)
    @Published var bookmarkSortOption: BookmarkSortOption = {
        let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.bookmarkSortOption.rawValue) ?? ""
        return BookmarkSortOption(rawValue: value) ?? .createdAtDescending
    }()
    
    @Injected(\.fetchBookmarksUseCase) private var fetchBookmarksUseCase
    @Injected(\.provideReloadEventPublisherUseCase) private var provideReloadEventPublisherUseCase
    @Injected(\.refreshBookmarkAfterDeletionUseCase) private var refreshBookmarkAfterDeletionUseCase
    
    private(set) var fetchTask: Task<Void, Never>?
    private(set) var reloadTask: Task<Void, Never>?
    private(set) var deleteTask: Task<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    func observePublisher() {
        provideReloadEventPublisherUseCase.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .normal:
                    self?.reloadData()
                case .preserveCount:
                    self?.reloadData(preserveCount: true)
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchBookmarks() {
        guard bookmarks.value.count % 20 == 0 else {
            // 현재까지 가져온 북마크의 개수가 20의 배수가 아닌 경우, 더 이상 가져올 데이터가 없다고 판단하고 추가 요청을 중단
            return
        }
        
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let fetchedBookmarks = try await fetchBookmarksUseCase.execute(page: bookmarks.value.count / 20, sortBy: bookmarkSortOption)
                let bookmarkSectionModels = fetchedBookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
                let value = bookmarks.value
                
                bookmarks.accept(value + bookmarkSectionModels)
            } catch {
                logger.error("BookmarkTableViewModel.fetchBookmarks() error : \(error.localizedDescription)")
            }
        }
    }
    
    func reloadData(preserveCount: Bool = false) {
        isRefreshing.accept(true)
        
        reloadTask?.cancel()
        reloadTask = Task {
            defer { isRefreshing.accept(false) }
            
            do {
                let fetchedBookmarks = try await fetchBookmarksUseCase.execute(
                    page: 0,
                    pageSize: preserveCount ? bookmarks.value.count : 20,
                    sortBy: bookmarkSortOption
                )
                let bookmarkSectionModels = fetchedBookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
                
                try await Task.sleep(nanoseconds: 300_000_000)
                
                bookmarks.accept(bookmarkSectionModels)
            } catch {
                logger.error("BookmarkTableViewModel.reloadData(preserveCount:) error : \(error.localizedDescription)")
            }
        }
    }
    
    func delete(bookmark: Bookmark) {
        deleteTask?.cancel()
        deleteTask = Task {
            do {
                let fetchedBookmarks = try await refreshBookmarkAfterDeletionUseCase.execute(
                    deletion: bookmark,
                    reloadCount: bookmarks.value.count - 1,
                    sortBy: bookmarkSortOption
                )
                let bookmarkSectionModels = fetchedBookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
                
                bookmarks.accept(bookmarkSectionModels)
            } catch {
                logger.error("BookmarkTableViewModel.delete(withId:) error : \(error.localizedDescription)")
            }
        }
    }
}
