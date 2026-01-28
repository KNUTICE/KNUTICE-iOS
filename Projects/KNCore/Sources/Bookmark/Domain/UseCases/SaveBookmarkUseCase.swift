//
//  SaveBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Factory
import Foundation
import UserNotifications

public protocol SaveBookmarkUseCase: Actor {
    /// Saves the given bookmark.
    /// - Parameter bookmark: The bookmark to be saved.
    func execute(_ bookmark: Bookmark) async throws
}

public actor SaveBookmarkUseCaseImpl: SaveBookmarkUseCase {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    
    public init() {}
    
    /// Executes the bookmark save flow:
    /// 1. Persists the bookmark in the local repository.
    /// 2. Registers a local notification associated with the bookmark.
    /// - Parameter bookmark: The bookmark to be processed.
    /// - Throws: An error if saving or scheduling the notification fails.
    public func execute(_ bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        // Bookmark 저장
        try await bookmarkRepository.save(bookmark: bookmark)
        
        if let alarmDate = bookmark.alarmDate {
            // 로컬 알림 스케줄 등록
            try await UNUserNotificationCenter.current().scheduleBookmarkNotification(
                id: String(bookmark.identity),
                date: alarmDate,
                body: bookmark.notice.title
            )
        }
    }
    
}
