//
//  BookmarkRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Factory
import Foundation
import KNUTICECore
import UserNotifications

actor BookmarkRepositoryImpl: BookmarkRepository {
    @Injected(\.bookmarkDataSource) private var dataSource
    
    // MARK: - Create
    
    /// Saves a new bookmark into the underlying data source.
    /// The repository checks for duplication using the domain entity's ID
    /// before converting the entity into a DTO.
    ///
    /// Note:
    /// - Repositories should convert Entities -> DTOs only inside the data layer.
    /// - DTOs are not exposed to upper layers (UseCase / ViewModel).
    func save(bookmark: Bookmark) async throws {
        let isExist = try await dataSource.isDuplication(id: bookmark.notice.id)
        
        guard !isExist else {
            throw ExistingBookmarkError.alreadyExist(message: "이미 존재하는 북마크에요.")
        }
        
        try await dataSource.save(bookmark.asDTO)
    }
    
    // MARK: - Read
    
    /// Fetches paginated bookmarks and maps DTOs to domain entities.
    /// DTOs stay within the data layer and are never returned to the domain.
    func fetch(page pageNum: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        let dto = try await dataSource.fetch(page: pageNum, pageSize: pageSize, sortBy: option)
        
        return dto.compactMap { $0.asEntity }
    }
    
    /// Fetches bookmarks that do not have timestamps.
    /// Useful for handling items that require additional processing.
    func fetchWhereTimestampsAreNil() async throws -> [Bookmark] {
        let dto = try await dataSource.fetchItemsWhereTimestampsAreNil()
        
        return dto.compactMap { $0.asEntity }
    }
    
    /// Performs keyword-based searching and returns the corresponding entities.
    /// Uses Task cancellation checks to ensure responsiveness.
    func search(with keyword: String) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        let dtos = try await dataSource.fetch(keyword: keyword)
        
        return dtos.compactMap { $0.asEntity }
    }
    
    /// Fetches a single bookmark by ID.
    /// Returns a mapped domain entity, or `nil` if not found.
    func fetch(id: Int) async throws -> Bookmark? {
        try Task.checkCancellation()
        
        let dto = try await dataSource.fetch(withId: id)
        
        return dto.flatMap { $0.asEntity }
    }
    
    // MARK: Delete
    
    /// Deletes a bookmark by ID.
    /// No entity mapping is needed for delete operations.
    func delete(by id: Int) async throws {
        try await dataSource.delete(by: id)
    }
    
    // MARK: - Update
    
    /// Updates an existing bookmark.
    /// Since updates involve domain rules, the domain entity is passed directly.
    func update(_ bookmark: Bookmark) async throws {
        try await dataSource.update(bookmark: bookmark)
    }
    
    /// Updates the timestamp-related values of a bookmark record.
    func updateTimeStamp(_ update: BookmarkUpdate) async throws {
        try await dataSource.updateTimeStamp(update)
    }
    
}

fileprivate extension Bookmark {
    /// Converts a domain `Bookmark` entity into a DTO.
    /// Entities should be mapped to DTOs only within the data layer.
    var asDTO: BookmarkDTO {
        BookmarkDTO(
            from: self.notice,
            memo: memo,
            alarmDate: alarmDate
        )
    }
}

fileprivate extension BookmarkDTO {
    /// Converts a DTO into a domain `Bookmark` entity.
    /// This ensures that upper layers (UseCase / ViewModel)
    /// operate only with pure domain models.
    var asEntity: Bookmark {
        let noticeData = self.noticeData
        return Bookmark(
            notice: Notice(
                id: Int(noticeData.nttID),
                title: noticeData.title,
                contentUrl: noticeData.contentURL,
                department: noticeData.department,
                uploadDate: noticeData.registrationDate,
                imageUrl: noticeData.contentImageURL,
                noticeCategory: NoticeCategory(rawValue: noticeData.topic),
                majorCategory: MajorCategory(rawValue: noticeData.topic)
            ),
            memo: self.memo ?? "",
            alarmDate: self.alarmDate
        )
    }
}
