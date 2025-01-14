//
//  BookmarkRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import Foundation

final class BookmarkRepositoryImpl: BookmarkRepository {
    enum ExistingBookmarkError: String, Error {
        case alreadyExist = "이미 존재하는 북마크에요."
    }
    
    private let dataSource: LocalBookmarkDataSource
    
    init(dataSource: LocalBookmarkDataSource) {
        self.dataSource = dataSource
    }
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return dataSource.isDuplication(id: bookmark.notice.id)
            .flatMap { isExist -> AnyPublisher<Void, any Error> in
                guard !isExist else {
                    return Fail(error: ExistingBookmarkError.alreadyExist)
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
                    self.getBookMark(from: dto)
                }
            }
            .delay(for: DispatchQueue.SchedulerTimeType.Stride(integerLiteral: delay), scheduler: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
    
    private func getBookMark(from dto: BookmarkDTO) -> Bookmark? {
        guard let noticeEntity = dto.notice else {
            return nil
        }
        
        return Bookmark(notice: Notice(id: Int(noticeEntity.id),
                                       boardNumber: nil,
                                       title: noticeEntity.title ?? "",
                                       contentUrl: noticeEntity.contentUrl ?? "",
                                       department: noticeEntity.department ?? "",
                                       uploadDate: noticeEntity.uploadDate ?? "",
                                       imageUrl: noticeEntity.imageUrl),
                        memo: dto.details ?? "",
                        alarmDate: dto.alarmDate)
    }
    
    func delete(by id: Int) -> AnyPublisher<Void, any Error> {
        return dataSource.delete(id: id)
    }
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return dataSource.update(bookmark: bookmark)
    }
}
