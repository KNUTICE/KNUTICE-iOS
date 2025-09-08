//
//  SearchCollectionViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import Factory
import RxRelay
import RxSwift
import os
import KNUTICECore

@MainActor
final class SearchViewModel: @MainActor NoticeSectionModelProvidable, @MainActor Searchable {
    let notices: BehaviorRelay<[NoticeSectionModel]> = .init(value: [])
    let bookmarks: BehaviorRelay<[Bookmark]> = .init(value: [])
    let keyword: BehaviorRelay<String> = .init(value: "")
    
    @Injected(\.searchService) private var searchService
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let logger: Logger = Logger()
    var tasks: [Task<Void, Never>] = []
    
    func search(with keyword: String) {
        guard !keyword.isEmpty else {
            notices.accept([])
            bookmarks.accept([])
            return
        }
        
        let task = Task {
            let result = await searchService.search(with: keyword)
            
            switch result {
            case .success((let notices, let bookmarks)):
                let noticeSectionModel = NoticeSectionModel(items: notices)
                
                self.notices.accept([noticeSectionModel])
                self.bookmarks.accept(bookmarks)
            case .failure(let error):
                logger.log("SearchTableViewModel.search(with:) error: \(error.localizedDescription)")
            }
        }
        
        tasks.append(task)
    }
}
