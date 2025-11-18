//
//  UpdateBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Factory
import Foundation
import KNUTICECore
import UserNotifications

protocol UpdateBookmarkUseCase: Actor {
    
    /// Updates the given bookmark.
    ///
    /// - Parameter bookmark: The bookmark containing updated information.
    /// - Throws: An error if updating the bookmark or handling notifications fails.
    func execute(for bookmark: Bookmark) async throws
}

actor UpdateBookmarkUseCaseImpl: UpdateBookmarkUseCase {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    
    /// Executes the update process for a bookmark:
    /// 1. Removes the existing scheduled local notification for the bookmark.
    /// 2. Registers a new notification based on the updated bookmark information.
    /// 3. Persists the updated bookmark into the repository.
    ///
    /// - Parameter bookmark: The bookmark to update.
    /// - Throws: An error if notification removal, scheduling, or repository update fails.
    func execute(for bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        // 기존 알림 삭제
        try await UNUserNotificationCenter.current().removeNotificationRequest(withId: bookmark.identity)
        
        // 새로운 알림 등록
        try await UNUserNotificationCenter.current().scheduleNotification(for: bookmark)
        
        // Bookmark 업데이트
        try await bookmarkRepository.update(bookmark)
    }
}
