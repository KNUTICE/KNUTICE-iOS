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
    let sortOption: BehaviorRelay<BookmarkSortOption> = {
        let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.bookmarkSortOption.rawValue) ?? "createdAtDescending"
        return BehaviorRelay(value: BookmarkSortOption(rawValue: value) ?? .createdAtDescending)
    }()
    @Injected(\.bookmarkRepository) private var repository
    @Injected(\.bookmarkService) private var bookmarkService
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    func fetchBookmarks() {
        guard bookmarks.value.count % 20 == 0 else {
            // 현재까지 가져온 북마크의 개수가 20의 배수가 아닌 경우, 더 이상 가져올 데이터가 없다고 판단하고 추가 요청을 중단
            return
        }
        
        repository.read(page: bookmarks.value.count / 20, sortBy: sortOption.value)
            .map { bookmarks in
                bookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkTableViewModel.fetchBookmarks() completed fetching bookmarks successfully")
                case .failure(let error):
                    self?.logger.error("BookmarkTableViewModel.fetchBookmarks() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] bookmarks in
                let value = self?.bookmarks.value ?? []
                self?.bookmarks.accept(value + bookmarks)
            })
            .store(in: &cancellables)
    }
    
    func reloadData() {
        isRefreshing.accept(true)
        repository.read(page: 0, sortBy: sortOption.value)
            .map { bookmarks in
                bookmarks.map {
                    BookmarkSectionModel(items: [$0])
                }
            }
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isRefreshing.accept(false)
                
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkTableViewModel.reloadData() successfully fetched bookmarks.")
                case .failure(let error):
                    self?.logger.error("BookmarkTableViewModel.reloadData() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] bookmarks in
                self?.bookmarks.accept(bookmarks)
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
