//
//  UpdateBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Foundation
import KNNotification
import UserNotifications

public protocol UpdateBookmarkUseCase: Sendable {
    
    /// Updates the given bookmark.
    ///
    /// - Parameter bookmark: The bookmark containing updated information.
    /// - Throws: An error if updating the bookmark or handling notifications fails.
    func execute(for bookmark: Bookmark) async throws
}

public final class UpdateBookmarkUseCaseImpl: UpdateBookmarkUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    /// Executes the update process for a bookmark:
    /// 1. Removes the existing scheduled local notification for the bookmark.
    /// 2. Registers a new notification based on the updated bookmark information.
    /// 3. Persists the updated bookmark into the repository.
    ///
    /// - Parameter bookmark: The bookmark to update.
    /// - Throws: An error if notification removal, scheduling, or repository update fails.
    public func execute(for bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        // 기존 알림 삭제
        try await UNUserNotificationCenter.current().removeNotificationRequest(withId: bookmark.id)
        
        if let alarmDate = bookmark.alarmDate {
            
            // 새로운 알림 등록
            try await UNUserNotificationCenter.current().scheduleBookmarkNotification(
                id: String(bookmark.id),
                date: alarmDate,
                body: bookmark.notice.title
            )
        }
        
        // Bookmark 업데이트
        try await bookmarkRepository.update(bookmark)
    }
}
