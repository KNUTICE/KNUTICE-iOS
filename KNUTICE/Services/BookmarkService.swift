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
}
