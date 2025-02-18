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
    func syncBookmarksWithNotice() -> AnyPublisher<[Bookmark], any Error>
}

final class BookmarkServiceImpl: BookmarkService {
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository
    @Injected(\.noticeRepository) private var noticeRepository: NoticeRepository
    
    func read(delay: Int) -> AnyPublisher<[Bookmark], any Error> {
        return bookmarkRepository.read(delay: delay)
    }
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)
            .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                return self.bookmarkRepository.save(bookmark: bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        if let _ = bookmark.alarmDate {
            //NotificationRequests 대기열에서 삭제
            UNUserNotificationCenter.current().removeNotificationRequest(with: .init(bookmark.notice.id))
            //NotificationRequests 대기열의 Badge Count 업데이트
            return UNUserNotificationCenter.current().updateNotificationRequestsBadgeAfterDeletion(by: .init(bookmark.notice.id))
                .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                    guard let self else {
                        return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                            .eraseToAnyPublisher()
                    }
                    
                    return self.bookmarkRepository.delete(by: bookmark.notice.id)
                }
                .eraseToAnyPublisher()
        } else {
            return bookmarkRepository.delete(by: bookmark.notice.id)
        }
    }
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        if let _ = bookmark.alarmDate {
            return UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)
                .flatMap { _ -> AnyPublisher<Void, any Error> in
                    UNUserNotificationCenter.current().updateNotificationRequestsBadge()
                }
                .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                    guard let self else {
                        return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                            .eraseToAnyPublisher()
                    }
                    
                    return self.bookmarkRepository.update(bookmark: bookmark)
                }
                .eraseToAnyPublisher()
        } else {
            return bookmarkRepository.update(bookmark: bookmark)
        }
    }
    
    /// CoreData에서 저장되어 있는 Notice 데이터를 서버 DB와 동기화 후 Bookmark 배열을 반환하는 함수
    func syncBookmarksWithNotice() -> AnyPublisher<[Bookmark], any Error> {
        return read(delay: 0)
            .flatMap { [weak self] bookmarks -> AnyPublisher<([Bookmark], [Notice]), any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
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
