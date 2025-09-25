//
//  BookmarkService.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/18/25.
//

import Factory
import UserNotifications
import KNUTICECore

protocol BookmarkService: Actor {
    /// Saves a bookmark and schedules a corresponding local notification.
    ///
    /// This function first persists the given `Bookmark` using the repository,
    /// and then registers a local notification associated with the bookmark's alarm date.
    /// Task cancellation is checked before execution to ensure safe termination.
    ///
    /// - Parameter bookmark: The `Bookmark` object to be saved and scheduled for notification.
    /// - Throws: An error if saving to the repository fails, notification scheduling fails,
    ///   or if the task is cancelled before completion.
    func save(bookmark: Bookmark) async throws
    
    /// Deletes a bookmark and cancels its associated local notification if scheduled.
    ///
    /// This function first checks for task cancellation.
    /// If the bookmark has no scheduled alarm (`alarmDate` is `nil`),
    /// it directly removes the bookmark data from the repository.
    /// Otherwise, it removes the pending notification request associated
    /// with the bookmark before deleting the bookmark from storage.
    ///
    /// - Parameter bookmark: The `Bookmark` object to be deleted.
    /// - Throws: An error if task cancellation occurs, removing the notification fails,
    ///   or deleting the bookmark from the repository fails.
    func delete(bookmark: Bookmark) async throws
    
    /// Deletes a bookmark and reloads a specified number of remaining bookmarks.
    ///
    /// This function first checks for task cancellation.
    /// It deletes the given `Bookmark` from storage, and then immediately
    /// fetches a refreshed list of bookmarks limited by the given `reloadCount`.
    /// The fetched bookmarks are sorted according to the provided `BookmarkSortOption`.
    ///
    /// - Parameters:
    ///   - bookmark: The `Bookmark` object to delete.
    ///   - reloadCount: The number of bookmarks to reload after deletion (used for refreshing the UI).
    ///   - option: The sorting option (`BookmarkSortOption`) that determines the order of the fetched bookmarks.
    /// - Returns: An array of `Bookmark` objects after deletion and reload.
    /// - Throws: An error if task cancellation occurs, bookmark deletion fails,
    ///   or fetching the updated bookmark list fails.
    func delete(bookmark: Bookmark, reloadCount: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark]
    
    /// Updates an existing bookmark and refreshes its associated local notification.
    ///
    /// This function first checks for task cancellation.
    /// It removes any previously scheduled local notification for the given `Bookmark`,
    /// then registers a new notification based on its latest configuration.
    /// Finally, it updates the `Bookmark` data in the repository.
    ///
    /// - Parameter bookmark: The `Bookmark` object containing updated information.
    /// - Throws: An error if task cancellation occurs, notification removal or scheduling fails,
    ///   or the repository update operation fails.
    func update(bookmark: Bookmark) async throws
    
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
    func fetchBookmarks(page: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark]
    
    /// Fetches a single bookmark by its identifier.
    ///
    /// Asynchronously queries the repository for a `Bookmark` whose identity matches 
    /// the given `id`. If no matching bookmark exists, this method returns `nil`.
    ///
    /// - Parameter id: The unique identifier of the bookmark to retrieve.
    /// - Returns: The matching `Bookmark` if found; otherwise, `nil`.
    /// - Throws: An error if the underlying repository read fails.
    func fetch(id: Int) async throws -> Bookmark?
}

extension BookmarkService {
    func fetchBookmarks(page: Int, pageSize: Int = 20, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        try await self.fetchBookmarks(page: page, pageSize: pageSize, sortBy: option)
    }
}

actor BookmarkServiceImpl: BookmarkService {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    @Injected(\.noticeRepository) private var noticeRepository: NoticeRepository
    
    func save(bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        // Bookmark 저장
        try await bookmarkRepository.save(bookmark: bookmark)
        
        // 로컬 알림 스케줄 등록
        try await UNUserNotificationCenter.current().scheduleNotification(for: bookmark)
    }
    
    func delete(bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        guard let _ = bookmark.alarmDate else {
            return try await bookmarkRepository.delete(by: bookmark.identity)
        }
        
        // 예약된 알림 스케줄 삭제
        try await UNUserNotificationCenter.current().removeNotificationRequest(withId: bookmark.identity)
        
        // Bookmark 데이터 삭제
        try await bookmarkRepository.delete(by: bookmark.notice.id)
    }
    
    func delete(bookmark: Bookmark, reloadCount: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        // Bookmark 삭제
        try await delete(bookmark: bookmark)
        
        // Bookmark 삭제 후, 갱신을 위해 나머지 데이터 가져오기
        return try await bookmarkRepository.fetch(page: 0, pageSize: reloadCount, sortBy: option)
    }
    
    func update(bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        // 기존 알림 삭제
        try await UNUserNotificationCenter.current().removeNotificationRequest(withId: bookmark.identity)
        
        // 새로운 알림 등록
        try await UNUserNotificationCenter.current().scheduleNotification(for: bookmark)
        
        // Bookmark 업데이트
        try await bookmarkRepository.update(bookmark)
    }
    
    func fetchBookmarks(page: Int, pageSize: Int = 20, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isBookmarkTimestampUpdated.rawValue) else {
            return try await bookmarkRepository.fetch(page: page, pageSize: pageSize, sortBy: option)
        }
        
        // createdAt 필드가 nil인 모든 Bookmark 데이터를 가져옴
        let incompleteBookmarks = try await bookmarkRepository.fetchWhereTimestampsAreNil()
        let updates = incompleteBookmarks.map {
            let timestamp = $0.notice.uploadDate.toDate() ?? Date()
            
            return BookmarkUpdate(
                bookmark: $0,
                createdAt: timestamp,
                updatedAt: timestamp
            )
        }
        
        // updatedAt, createdAt 필드 업데이트
        try await withThrowingTaskGroup { group in
            for update in updates {
                group.addTask {
                    try await self.bookmarkRepository.updateTimeStamp(update)
                }
            }
            
            try await group.waitForAll()
        }
        
        // timestamp update flag 값을 true로 변경
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isBookmarkTimestampUpdated.rawValue)
        
        // 업데이트 된 Bookmark 조회
        return try await bookmarkRepository.fetch(page: page, pageSize: pageSize, sortBy: option)
    }
    
    func fetch(id: Int) async throws -> Bookmark? {
        return try await bookmarkRepository.fetch(id: id)
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

