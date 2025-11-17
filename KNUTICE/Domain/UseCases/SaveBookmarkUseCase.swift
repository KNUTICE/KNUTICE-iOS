//
//  SaveBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Factory
import Foundation
import KNUTICECore
import UserNotifications

protocol SaveBookmarkUseCase: Actor {
    /// Saves the given bookmark.
    /// - Parameter bookmark: The bookmark to be saved.
    func execute(_ bookmark: Bookmark) async throws
}

actor SaveBookmarkUseCaseImpl: SaveBookmarkUseCase {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    
    /// Executes the bookmark save flow:
    /// 1. Persists the bookmark in the local repository.
    /// 2. Registers a local notification associated with the bookmark.
    /// - Parameter bookmark: The bookmark to be processed.
    /// - Throws: An error if saving or scheduling the notification fails.
    func execute(_ bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        // Bookmark 저장
        try await bookmarkRepository.save(bookmark: bookmark)
        
        // 로컬 알림 스케줄 등록
        try await UNUserNotificationCenter.current().scheduleNotification(for: bookmark)
    }
    
}
