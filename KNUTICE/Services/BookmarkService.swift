//
//  BookmarkService.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/18/25.
//

import Combine
import UserNotifications

protocol BookmarkService {
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func delete(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
}

final class BookmarkServiceImpl: BookmarkService {
    private let repository: BookmarkRepository
    
    init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)
            .flatMap { _ -> AnyPublisher<Void, any Error> in
                self.repository.save(bookmark: bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        if let _ = bookmark.alarmDate {
            //NotificationRequests 대기열에서 삭제
            UNUserNotificationCenter.current().removeNotificationRequest(with: .init(bookmark.notice.id))
            //NotificationRequests 대기열의 Badge Count 업데이트
            return UNUserNotificationCenter.current().updateNotificationRequestsBadgeAfterDeletion(by: .init(bookmark.notice.id))
                .flatMap { _ -> AnyPublisher<Void, any Error> in
                    self.repository.delete(by: bookmark.notice.id)
                }
                .eraseToAnyPublisher()
        } else {
            return repository.delete(by: bookmark.notice.id)
        }
    }
}
