//
//  BookmarkRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import Foundation

final class BookmarkRepositoryImpl: BookmarkRepository {
    private let dataSource: LocalBookmarkDataSource
    
    init(dataSource: LocalBookmarkDataSource) {
        self.dataSource = dataSource
    }
    
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return dataSource.save(bookmark)
    }
    
    func read(delay: Int) -> AnyPublisher<[Bookmark], any Error> {
        return dataSource.read()
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
                        details: dto.details ?? "",
                        alarmDate: dto.alarmDate)
    }
}
