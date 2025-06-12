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
    let isRefreshing: BehaviorRelay<Bool> = .init(value: false)
    @Injected(\.bookmarkRepository) private var repository
    @Injected(\.bookmarkService) private var bookmarkService
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    func fetchBookmarks(isRefreshing: Bool = false) {
        if isRefreshing {
            self.isRefreshing.accept(true)
        }
        
        repository.read(page: bookmarks.value.count / 20, delay: 0)
            .map { bookmarks in
                bookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
            }
            .delay(for: .milliseconds(isRefreshing ? 200 : 0), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if isRefreshing {
                    self?.isRefreshing.accept(false)
                }
                
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkTableViewModel.fetchBookmarks() completed fetching bookmarks successfully")
                case .failure(let error):
                    self?.logger.error("BookmarkTableViewModel.fetchBookmarks() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] bookmarks in
                if isRefreshing {
                    self?.bookmarks.accept(bookmarks)
                } else {
                    let value = self?.bookmarks.value ?? []
                    self?.bookmarks.accept(value + bookmarks)
                }
            })
            .store(in: &cancellables)
    }
    
    func delete(bookmark: Bookmark) {
        bookmarkService.delete(bookmark: bookmark, reloadCount: bookmarks.value.count - 1)
            .map { bookmarks in
                bookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkTableViewModel.delete(bookmark:) ")
                case .failure(let error):
                    self?.logger.error("BookmarkTableViewModel.delete(bookmark:) error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] bookmarks in
                self?.bookmarks.accept(bookmarks)
            })
            .store(in: &cancellables)
    }
}
