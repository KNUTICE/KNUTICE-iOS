//
//  DeleteBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Factory
import Foundation
import KNUTICECore
import UserNotifications

protocol DeleteBookmarkUseCase: Actor {
    /// Deletes the given bookmark.
    /// - Parameter bookmark: The bookmark to be removed.
    func execute(for bookmark: Bookmark) async throws
}

actor DeleteBookmarkUseCaseImpl: DeleteBookmarkUseCase {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    
    /// Executes the deletion flow for a given bookmark:
    /// 1. If the bookmark has no scheduled alarm, it is deleted immediately.
    /// 2. If an alarm exists, the scheduled local notification is removed.
    /// 3. Finally, the bookmark data is deleted from the local repository.
    ///
    /// - Parameter bookmark: The bookmark to delete.
    /// - Throws: An error if deleting the bookmark or removing the notification fails.
    func execute(for bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        guard let _ = bookmark.alarmDate else {
            return try await bookmarkRepository.delete(by: bookmark.identity)
        }
        
        // 예약된 알림 스케줄 삭제
        try await UNUserNotificationCenter.current().removeNotificationRequest(withId: bookmark.identity)
        
        // Bookmark 데이터 삭제
        try await bookmarkRepository.delete(by: bookmark.notice.id)
    }
    
}
