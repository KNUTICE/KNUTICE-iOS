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
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
}

final class BookmarkServiceImpl: BookmarkService {
    @Injected(\.bookmarkRepository) private var repository: BookmarkRepository
//    @Injected()
    
    func read(delay: Int) -> AnyPublisher<[Bookmark], any Error> {
        return repository.read(delay: delay)
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
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        if let _ = bookmark.alarmDate {
            return UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)
                .flatMap { _ -> AnyPublisher<Void, any Error> in
                    UNUserNotificationCenter.current().updateNotificationRequestsBadge()
                }
                .flatMap {
                    self.repository.update(bookmark: bookmark)
                }
                .eraseToAnyPublisher()
        } else {
            return repository.update(bookmark: bookmark)
        }
    }
    
}
