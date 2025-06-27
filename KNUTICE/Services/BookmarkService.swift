//
//  BookmarkService.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/18/25.
//

import Combine
import Factory
import UserNotifications

protocol BookmarkService {
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func delete(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    
    /// Deletes a specific `Bookmark` and then fetches the latest list of bookmarks
    /// to reflect the updated state.
    ///
    /// - Parameters:
    ///   - bookmark: The `Bookmark` to be deleted.
    ///   - reloadCount: The number of bookmarks to reload after deletion (used for pagination).
    ///   - option: The sorting option to apply when re-fetching bookmarks.
    ///
    /// - Returns: An `AnyPublisher<[Bookmark], Error>` that emits the updated list
    ///   of bookmarks after the deletion completes.
    ///
    /// - Workflow:
    ///   1. Deletes the given bookmark by calling `delete(bookmark:)`.
    ///   2. If deletion succeeds, fetches the first page of bookmarks (up to `reloadCount`)
    ///      sorted by the specified option.
    ///   3. If `self` is deallocated during the process, returns an empty list.
    func delete(
        bookmark: Bookmark,
        reloadCount: Int,
        sortBy option: BookmarkSortOption
    ) -> AnyPublisher<[Bookmark], any Error>
    
    /// Updates an existing `Bookmark`, synchronizing its local notification if needed
    /// and persisting the changes to storage.
    ///
    /// Workflow:
    /// 1. **Remove** the previous notification associated with the bookmark’s `notice.id`.
    /// 2. **(Re-)Register** a local notification *only* if:
    ///    * `alarmDate` is non-nil, **and**
    ///    * `alarmDate` is in the future.
    /// 3. **Persist** the updated bookmark in the repository.
    ///
    /// - Parameter bookmark: The `Bookmark` domain model containing the latest
    ///   `memo`, `alarmDate`, or other user-edited fields.
    /// - Returns: An `AnyPublisher<Void, Error>` that:
    ///   * completes (`.finished`) on success, or
    ///   * fails if any step (notification removal, registration, persistence)
    ///     throws an error.
    ///
    /// - Important:
    ///   This method chains three asynchronous Combine publishers.
    ///   Use `[weak self]` to avoid retain cycles; if `self` is deallocated while
    ///   the chain is active, the publisher fails with a `"SelfDeallocated"` error.
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    
    func syncBookmarksWithNotice() -> AnyPublisher<[Bookmark], any Error>
    
    /// Fetches paginated bookmarks, performing a migration for
    /// pre-1.5.0 records whose `createdAt` is `nil`.
    ///
    /// - Parameters:
    ///   - page: Zero-based page index.
    ///   - pageSize: Maximum number of items per page (default = 20).
    ///   - option: Sorting criterion used by the repository
    ///             (default = `.createdAtDescending`).
    ///
    /// - Returns: An `AnyPublisher<[Bookmark], Error>` that emits the requested
    ///            page of bookmarks or an error.
    ///
    /// - Important:
    ///   * Prior to version 1.5.0, bookmarks were stored without a `createdAt`
    ///     value. When the flag `isBookmarkUpdatedAfter1_5_0` is **false**,
    ///     this method:
    ///       1. Reads those legacy bookmarks (`fetchWithNilCreatedAt()`).
    ///       2. Derives a creation date from each bookmark’s
    ///          `notice.uploadDate` (or `Date()` as fallback).
    ///       3. Persists the newly computed `createdAt` values via
    ///          `update(bookmarks:)`.
    ///       4. Finally reads the requested page.
    ///   * When the flag is **true**, the repository is already migrated and the
    ///     method simply reads the requested page.
    ///
    /// - Note: `Deferred` is used so that the entire Combine chain is created
    ///         lazily—only when someone subscribes.
    func fetchBookmarks(
        page: Int,
        pageSize: Int,
        sortBy option: BookmarkSortOption
    ) -> AnyPublisher<[Bookmark], any Error>
}

extension BookmarkService {
    func fetchBookmarks(
        page: Int,
        pageSize: Int = 20,
        sortBy option: BookmarkSortOption
    ) -> AnyPublisher<[Bookmark], any Error> {
        self.fetchBookmarks(page: page, pageSize: pageSize, sortBy: option)
    }
}

final class BookmarkServiceImpl: BookmarkService {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    @Injected(\.noticeRepository) private var noticeRepository: NoticeRepository
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return bookmarkRepository.save(bookmark: bookmark)
            .flatMap { _ -> AnyPublisher<Void, any Error> in
                UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        if let _ = bookmark.alarmDate {
            return UNUserNotificationCenter.current().removeNotificationRequest(from: bookmark)    //NotificationRequests 대기열에서 삭제
                .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                    guard let self else {
                        return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                            .eraseToAnyPublisher()
                    }
                    
                    return self.bookmarkRepository.delete(by: bookmark.notice.id)    //CoreData 데이터 삭제
                }
                .eraseToAnyPublisher()
        } else {
            return bookmarkRepository.delete(by: bookmark.notice.id)
        }
    }
    
    func delete(
        bookmark: Bookmark,
        reloadCount: Int,
        sortBy option: BookmarkSortOption
    ) -> AnyPublisher<[Bookmark], any Error> {
        return delete(bookmark: bookmark)
            .flatMap { [weak self] _ -> AnyPublisher<[Bookmark], any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                return self.bookmarkRepository.read(page: 0, pageSize: reloadCount, sortBy: option)
            }
            .eraseToAnyPublisher()
    }
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return UNUserNotificationCenter.current().removeNotificationRequest(from: bookmark)    //기존 알림 삭제
            .flatMap { _ -> AnyPublisher<Void, any Error> in
                guard let alarmDate = bookmark.alarmDate, alarmDate > Date() else {
                    return Just(())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)    //새로운 알림 등록
            }
            .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                return self.bookmarkRepository.update(bookmark: bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchBookmarks(
        page: Int,
        pageSize: Int = 20,
        sortBy option: BookmarkSortOption
    ) -> AnyPublisher<[Bookmark], any Error> {
        return Deferred {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isBookmarkUpdatedAfter1_5_0.rawValue) {
                return self.bookmarkRepository.fetchWhereCreatedAtIsNil()    //createdAt 필드가 nil인 모든 Bookmark 데이터를 가져옴
                    .map { bookmarks in
                        bookmarks.map {
                            ($0, $0.notice.uploadDate.toDate() ?? Date())    //createdAt 필드에 업데이트할 값을 튜플 형태로 반환
                        }
                    }
                    .flatMap { [weak self] bookmarks -> AnyPublisher<Void, any Error> in
                        guard let self else {
                            return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                                .eraseToAnyPublisher()
                        }
                        
                        return self.bookmarkRepository.update(bookmarks: bookmarks)    //Bookmark 업데이트
                    }
                    .flatMap { [weak self] _ -> AnyPublisher<[Bookmark], any Error> in
                        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isBookmarkUpdatedAfter1_5_0.rawValue)
                        
                        guard let self else {
                            return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                                .eraseToAnyPublisher()
                        }
                        
                        return self.bookmarkRepository.read(page: page, pageSize: pageSize, sortBy: option)    //페이지네이션으로 Bookmark 조회
                    }
                    .eraseToAnyPublisher()
            } else {
                return self.bookmarkRepository.read(page: page, pageSize: pageSize, sortBy: option)
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// CoreData에서 저장되어 있는 Notice 데이터를 서버 DB와 동기화 후 Bookmark 배열을 반환하는 함수
    func syncBookmarksWithNotice() -> AnyPublisher<[Bookmark], any Error> {
        return bookmarkRepository.read(page: 0, pageSize: 0, sortBy: .createdAtDescending)
            .flatMap { [weak self] bookmarks -> AnyPublisher<([Bookmark], [Notice]), any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                guard !bookmarks.isEmpty else {
                    //bookmark가 없는 경우 빈 배열 전달
                    return Just(([], []))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                //저장된 Notice id를 통해 서버에 새로운 Notice 요청
                let nttIds: [Int] = bookmarks.map { bookmark in
                    bookmark.notice.id
                }
                
                return self.noticeRepository.fetchNotices(by: nttIds)
                    .map { notices in
                        (bookmarks, notices)
                    }
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] (bookmarks, notices) -> AnyPublisher<([Void], [Bookmark]), any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                guard !bookmarks.isEmpty && !notices.isEmpty else {
                    //bookmarks와 notices가 없는 경우 빈 배열 전달
                    return Just(([], []))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                //새로운 Notice로 Bookmark 업데이트
                var updatedBookmarks: [Bookmark] = []
                for (bookmark, notice) in zip(bookmarks, notices) {
                    updatedBookmarks.append(
                        Bookmark(notice: notice, memo: bookmark.memo, alarmDate: bookmark.alarmDate)
                    )
                }
                
                return Publishers.MergeMany(
                    updatedBookmarks.map {
                        self.update(bookmark: $0)
                    }
                )
                .collect()    //모든 Bookmark가 저장될 때까지 대기
                .map { results in
                    (results, updatedBookmarks)
                }
                .eraseToAnyPublisher()
            }
            .map { (_, updatedBookmarks) in
                return updatedBookmarks
            }
            .eraseToAnyPublisher()
    }
}

fileprivate extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return dateFormatter.date(from: self)
    }
}
