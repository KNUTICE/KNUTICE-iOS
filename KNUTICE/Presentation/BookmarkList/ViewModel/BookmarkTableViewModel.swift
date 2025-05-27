//
//  BookmarkTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Combine
import Factory
import Foundation
import RxRelay
import RxSwift
import os

final class BookmarkTableViewModel {
    let bookmarks: BehaviorRelay<[BookmarkSectionModel]> = .init(value: [])
    @Injected(\.bookmarkRepository) private var repository
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    func fetchBookmarks() {
        repository.read(delay: 0)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkTableViewModel.fetchBookmarks() completed fetching bookmarks successfully")
                case .failure(let error):
                    self?.logger.error("BookmarkTableViewModel.fetchBookmarks() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] bookmarks in
                let sectionModels: [BookmarkSectionModel] = bookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
                self?.bookmarks.accept(sectionModels)
            })
            .store(in: &cancellables)
    }
}
