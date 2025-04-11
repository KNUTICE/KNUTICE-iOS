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
    
    func read(delay: Int = 0) -> AnyPublisher<[Bookmark], any Error> {
        return bookmarkRepository.read(delay: delay)
    }
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return bookmarkRepository.save(bookmark: bookmark)
            .flatMap { _ -> AnyPublisher<Void, any Error> in
                UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    func delete(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        if let _ = bookmark.alarmDate {
            return UNUserNotificationCenter.current().removeNotificationRequest(from: bookmark)    //NotificationRequests 대기열에서 삭제
                .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                    guard let self else {
                        return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                            .eraseToAnyPublisher()
                    }
                    
                    return self.bookmarkRepository.delete(by: bookmark.notice.id)    //CoreData 데이터 삭제
                }
                .eraseToAnyPublisher()
        } else {
            return bookmarkRepository.delete(by: bookmark.notice.id)
        }
    }
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return UNUserNotificationCenter.current().removeNotificationRequest(from: bookmark)    //기존 알림 삭제
            .flatMap { _ -> AnyPublisher<Void, any Error> in
                guard let alarmDate = bookmark.alarmDate, alarmDate > Date() else {
                    return Just(())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return UNUserNotificationCenter.current().registerLocalNotification(for: bookmark)    //새로운 알림 등록
            }
            .flatMap { [weak self] _ -> AnyPublisher<Void, any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                return self.bookmarkRepository.update(bookmark: bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    /// CoreData에서 저장되어 있는 Notice 데이터를 서버 DB와 동기화 후 Bookmark 배열을 반환하는 함수
    func syncBookmarksWithNotice() -> AnyPublisher<[Bookmark], any Error> {
        return read()
            .flatMap { [weak self] bookmarks -> AnyPublisher<([Bookmark], [Notice]), any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                guard !bookmarks.isEmpty else {
                    //bookmark가 없는 경우 빈 배열 전달
                    return Just(([], []))
                        .setFailureType(to: Error.self)
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
                
                guard !bookmarks.isEmpty && !notices.isEmpty else {
                    //bookmarks와 notices가 없는 경우 빈 배열 전달
                    return Just(([], []))
                        .setFailureType(to: Error.self)
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
