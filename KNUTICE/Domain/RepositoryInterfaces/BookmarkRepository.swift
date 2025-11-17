//
//  BookmarkRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Foundation
import KNUTICECore

protocol BookmarkRepository: Sendable {
    func save(bookmark: Bookmark) async throws
    
    func fetch(page pageNum: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark]
    
    func fetchWhereTimestampsAreNil() async throws -> [Bookmark]
    
    func delete(by id: Int) async throws
    
    func update(_ bookmark: Bookmark) async throws
    
    func updateTimeStamp(_ update: BookmarkUpdate) async throws
    
    func search(with keyword: String) async throws -> [Bookmark]
    
    func fetch(id: Int) async throws -> Bookmark?
}

protocol BookmarkCreatable {
    func createBookMark(from dto: BookmarkDTO) -> Bookmark?
}

extension BookmarkCreatable {
    func createBookMark(from dto: BookmarkDTO) -> Bookmark? {
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
                noticeCategory: NoticeCategory(rawValue: noticeEntity.category ?? ""),
                majorCategory: MajorCategory(rawValue: noticeEntity.category ?? "")
            ),
            memo: dto.details ?? "",
            alarmDate: dto.alarmDate
        )
    }
}
