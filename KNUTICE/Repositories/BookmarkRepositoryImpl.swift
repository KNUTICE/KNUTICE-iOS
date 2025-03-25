//
//  BookmarkRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import UserNotifications
import Factory
import Foundation

final class BookmarkRepositoryImpl: BookmarkRepository {
    @Injected(\.localBookmarkDataSource) private var dataSource: LocalBookmarkDataSource
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return dataSource.isDuplication(id: bookmark.notice.id)
            .flatMap { isExist -> AnyPublisher<Void, any Error> in
                guard !isExist else {
                    return Fail(error: ExistingBookmarkError.alreadyExist(message: "이미 존재하는 북마크에요."))
                        .eraseToAnyPublisher()
                }
                
                return self.dataSource.save(bookmark)
            }
            .eraseToAnyPublisher()
    }
    
    func read(delay: Int) -> AnyPublisher<[Bookmark], any Error> {
        return dataSource.readDTO()
            .map {
                $0.compactMap { dto in
                    self.createBookMark(from: dto)
                }
            }
            .delay(for: DispatchQueue.SchedulerTimeType.Stride(integerLiteral: delay), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
    
    private func createBookMark(from dto: BookmarkDTO) -> Bookmark? {
        guard let noticeEntity = dto.notice else {
            return nil
        }
        
        return Bookmark(
            notice: Notice(
                id: Int(noticeEntity.id),
                title: noticeEntity.title ?? "",
                contentUrl: noticeEntity.contentUrl ?? "",
                department: noticeEntity.department ?? "",
                uploadDate: noticeEntity.uploadDate ?? "",
                imageUrl: noticeEntity.imageUrl,
                noticeCategory: NoticeCategory(rawValue: noticeEntity.category ?? "")
            ),
            memo: dto.details ?? "",
            alarmDate: dto.alarmDate
        )
    }
    
    func delete(by id: Int) -> AnyPublisher<Void, any Error> {
        return dataSource.delete(id: id)
    }
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return dataSource.update(bookmark: bookmark)
    }
}
