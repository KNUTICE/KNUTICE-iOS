//
//  SwiftDataBookmarkRepository.swift
//  KNData
//
//  Created by 이정훈 on 7/10/26.
//

@preconcurrency import Combine
import Factory
import Foundation
import KNDomain
import KNUtility

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
public actor SwiftDataBookmarkRepository: BookmarkRepository {
    /// A publisher that emits reload events when bookmark data changes.
    ///
    /// The publisher is exposed as `nonisolated` so subscribers can observe
    /// changes without crossing the repository actor boundary.
    nonisolated public var eventPublisher: AnyPublisher<ReloadEvent, Never> {
        eventTrigger.eraseToAnyPublisher()
    }
    
    /// The shared SwiftData-backed bookmark repository instance.
    public static let shared: SwiftDataBookmarkRepository = .init()
    
    /// Internal subject used to notify observers after bookmark mutations.
    private nonisolated let eventTrigger: PassthroughSubject<ReloadEvent, Never> = .init()
    
    /// The SwiftData-backed data store injected through Factory.
    @Injected(\.bookmarkDataStore) private var dataStore
    
    /// Creates a repository that resolves its dependencies from Factory.
    private init() {}
    
    // MARK: - Create
    
    /// Saves a new bookmark after checking for an existing bookmark with the same notice ID.
    ///
    /// - Parameter bookmark: The bookmark domain entity to persist.
    /// - Throws: `ExistingBookmarkError.alreadyExist` if the bookmark already exists,
    ///   or an error from the underlying SwiftData store.
    public func save(bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        let existingBookmark = try await dataStore.fetch(id: bookmark.notice.id)
        
        guard existingBookmark == nil else {
            throw ExistingBookmarkError.alreadyExist(message: "이미 존재하는 북마크에요.")
        }
        
        try await dataStore.save(bookmark)
        eventTrigger.send(.normal)
    }
    
    // MARK: - Read
    
    /// Fetches bookmarks using pagination and the requested sort option.
    ///
    /// - Parameters:
    ///   - pageNum: The zero-based page index to fetch.
    ///   - pageSize: The number of bookmarks to fetch per page.
    ///   - option: The sort option used by the data store.
    /// - Returns: A list of bookmark domain entities for the requested page.
    /// - Throws: An error from the underlying SwiftData store.
    public func fetch(
        page pageNum: Int,
        pageSize: Int,
        sortBy option: BookmarkSortOption
    ) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        return try await dataStore.fetch(
            sortBy: option,
            fetchLimit: pageSize,
            fetchOffset: pageNum * pageSize
        ).map(\.asEntity)
    }
    
    /// Fetches a single bookmark by its notice ID.
    ///
    /// - Parameter id: The notice ID associated with the bookmark.
    /// - Returns: The matching bookmark, or `nil` if no bookmark exists.
    /// - Throws: An error from the underlying SwiftData store.
    public func fetch(id: Int) async throws -> Bookmark? {
        try Task.checkCancellation()
        
        return try await dataStore.fetch(id: id)?.asEntity
    }
    
    // MARK: - Delete
    
    /// Deletes the bookmark associated with the given notice ID.
    ///
    /// - Parameter id: The notice ID associated with the bookmark to delete.
    /// - Throws: An error from the underlying SwiftData store.
    public func delete(by id: Int) async throws {
        try Task.checkCancellation()
        
        try await dataStore.delete(id: id)
        eventTrigger.send(.normal)
    }
    
    // MARK: - Update
    
    /// Updates the memo and alarm date for an existing bookmark.
    ///
    /// - Parameter bookmark: The bookmark containing the latest values.
    /// - Throws: An error from the underlying SwiftData store.
    public func update(_ bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        try await dataStore.update(bookmark)
        eventTrigger.send(.preserveCount)
    }
    
    // MARK: - Search
    
    /// Searches bookmarks whose searchable fields contain the provided keyword.
    ///
    /// - Parameter keyword: The text used to filter bookmark memo and notice title values.
    /// - Returns: A list of matching bookmark domain entities.
    /// - Throws: An error from the underlying SwiftData store.
    public func search(with keyword: String) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        return try await dataStore.fetch(
            keyword: keyword,
            fetchLimit: 0,
            fetchOffset: 0
        ).map(\.asEntity)
    }
}

fileprivate extension BookmarkModel {
    var asEntity: Bookmark {
        Bookmark(
            notice: notice.asEntity,
            memo: memo,
            alarmDate: alarmDate
        )
    }
}

fileprivate extension NoticeModel {
    var asEntity: Notice {
        Notice(
            id: id,
            title: title,
            contentURL: contentURL,
            isSummarizable: isSummarizable,
            department: department,
            uploadDate: uploadDate,
            imageURL: imageURL,
            topicId: topicId
        )
    }
}
