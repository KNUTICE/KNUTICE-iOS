//
//  BookmarkTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Factory
import Foundation
import KNUTICECore
import RxRelay
import RxSwift
import os

@MainActor
final class BookmarkTableViewModel {
    let bookmarks: BehaviorRelay<[BookmarkSectionModel]> = .init(value: [])
    let isRefreshing: BehaviorRelay<Bool> = .init(value: false)
    
    let sortOption: BehaviorRelay<BookmarkSortOption> = {
        let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.bookmarkSortOption.rawValue) ?? "createdAtDescending"
        return BehaviorRelay(value: BookmarkSortOption(rawValue: value) ?? .createdAtDescending)
    }()
    
    @Injected(\.bookmarkService) private var bookmarkService
    
    private(set) var fetchTask: Task<Void, Never>?
    private(set) var reloadTask: Task<Void, Never>?
    private(set) var deleteTask: Task<Void, Never>?
    private let logger: Logger = Logger()
    
    func fetchBookmarks() {
        guard bookmarks.value.count % 20 == 0 else {
            // 현재까지 가져온 북마크의 개수가 20의 배수가 아닌 경우, 더 이상 가져올 데이터가 없다고 판단하고 추가 요청을 중단
            return
        }
        
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let fetchedBookmarks = try await bookmarkService.fetchBookmarks(page: bookmarks.value.count / 20, sortBy: sortOption.value)
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
                let fetchedBookmarks = try await bookmarkService.fetchBookmarks(
                    page: 0,
                    pageSize: preserveCount ? bookmarks.value.count : 20,
                    sortBy: sortOption.value
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
                let fetchedBookmarks = try await bookmarkService.delete(
                    bookmark: bookmark,
                    reloadCount: bookmarks.value.count - 1,
                    sortBy: sortOption.value
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
