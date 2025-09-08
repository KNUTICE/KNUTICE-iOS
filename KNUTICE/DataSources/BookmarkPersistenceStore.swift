//
//  BookmarkPersistenceStore.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/7/25.
//

import CoreData
import Foundation
import KNUTICECore

protocol BookmarkPersistenceStore: Sendable {
    /// Saves a `Bookmark` into the persistent store.
    ///
    /// This method creates both a `BookmarkEntity` and its associated `NoticeEntity`
    /// inside the given background context. The operation is performed using
    /// `.enqueued` scheduling to ensure safe, sequential writes.
    ///
    /// - Parameter bookmark: The `Bookmark` domain model to be saved.
    /// - Throws: An error if the context fails to save changes.
    func save(_ bookmark: Bookmark) async throws
    
    /// Fetches a paginated list of bookmarks from the persistent store.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch (0-based indexing).
    ///   - pageSize: The maximum number of items to fetch per page.
    ///   - sortBy: The sorting option to apply to the results.
    /// - Returns: An array of `BookmarkDTO` representing the fetched bookmarks.
    /// - Throws: An error if the fetch request fails.
    func fetch(page: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [BookmarkDTO]
    
    /// Checks whether a bookmark with the given notice ID already exists.
    ///
    /// - Parameter id: The ID of the notice to check for duplication.
    /// - Returns: `true` if a bookmark with the specified notice ID exists; otherwise, `false`.
    /// - Throws: An error if the fetch request fails.
    func isDuplication(id: Int) async throws -> Bool
    
    /// Fetches all bookmarks where either the `createdAt` or `updatedAt` timestamp is `nil`.
    ///
    /// This can be used to identify incomplete or partially initialized bookmarks in the persistent store.
    ///
    /// - Returns: An array of `BookmarkDTO` representing bookmarks with missing timestamps.
    /// - Throws: An error if the fetch request fails.
    func fetchItemsWhereTimestampsAreNil() async throws -> [BookmarkDTO]
    
    /// Fetches bookmarks where either the notice title or the memo contains the specified keyword.
    ///
    /// - Parameter keyword: The search keyword to filter bookmarks by title or memo content.
    /// - Returns: An array of `BookmarkDTO` representing bookmarks that match the keyword.
    /// - Throws: An error if the fetch request fails.
    func fetch(keyword: String) async throws -> [BookmarkDTO]
    
    /// Deletes all bookmarks associated with the specified notice ID.
    ///
    /// - Parameter id: The ID of the notice whose bookmarks should be deleted.
    /// - Throws: An error if fetching the bookmarks or saving the context fails.
    func delete(by id: Int) async throws
    
    /// Updates an existing bookmark with new memo and alarm date values.
    ///
    /// - Parameter bookmark: The `Bookmark` containing updated information.
    /// - Throws: An error if fetching the bookmark or saving changes to the context fails.
    func update(bookmark: Bookmark) async throws
    
    func updateTimeStamp(_ update: BookmarkUpdate) async throws
}

extension BookmarkPersistenceStore {
    func fetch(
        page: Int, pageSize: Int = 20,
        sortBy option: BookmarkSortOption
    ) async throws -> [BookmarkDTO] {
        try await self.fetch(page: page, pageSize: pageSize, sortBy: option)
    }
}

actor BookmarkPersistenceStoreImpl: BookmarkPersistenceStore {
    static let shared: BookmarkPersistenceStoreImpl = .init()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Bookmark")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    private init() {}
    
    // MARK: - Save
    
    func save(_ bookmark: Bookmark) async throws {
        let context = backgroundContext
        
        try Task.checkCancellation()
        
        try await context.perform(schedule: .enqueued) {
            // BookmarkEntity
            let bookmarkEntity = BookmarkEntity(context: context)
            bookmarkEntity.memo = bookmark.memo
            bookmarkEntity.alarmDate = bookmark.alarmDate
            bookmarkEntity.createdAt = Date()
            
            // NoticeEntity
            let noticeEntity = NoticeEntity(context: context)
            noticeEntity.id = Int64(bookmark.notice.id)
            noticeEntity.title = bookmark.notice.title
            noticeEntity.department = bookmark.notice.department
            noticeEntity.uploadDate = bookmark.notice.uploadDate
            noticeEntity.contentUrl = bookmark.notice.contentUrl
            noticeEntity.imageUrl = bookmark.notice.imageUrl
            noticeEntity.category = bookmark.notice.noticeCategory?.rawValue
            
            bookmarkEntity.bookmarkedNotice = noticeEntity
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    // MARK: - Fetch
    
    func fetch(page: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [BookmarkDTO] {
        try Task.checkCancellation()
        
        let entities = try await fetchBookmarkEntities(
            fetchLimit: pageSize,
            fetchOffset: page * pageSize,
            sortDescriptors: [option.descriptor]
        )
        
        return createBookmarkDTOs(from: entities)
    }
    
    func isDuplication(id: Int) async throws -> Bool {
        try Task.checkCancellation()
        
        let entities = try await fetch(withId: id)
        
        return !entities.isEmpty
    }
    
    func fetchItemsWhereTimestampsAreNil() async throws -> [BookmarkDTO] {
        try Task.checkCancellation()
        
        let entities = try await fetchBookmarkEntities(
            predicate: NSPredicate(format: "createdAt == nil OR updatedAt == nil")
        )
        
        return createBookmarkDTOs(from: entities)
    }
    
    func fetch(keyword: String) async throws -> [BookmarkDTO] {
        try Task.checkCancellation()
        
        let entities = try await fetchBookmarkEntities(
            predicate: NSPredicate(format: "bookmarkedNotice.title CONTAINS %@ OR memo CONTAINS %@", keyword, keyword)
        )
        
        return createBookmarkDTOs(from: entities)
    }
    
    private func fetch(withId id: Int) async throws -> [BookmarkEntity] {
        return try await fetchBookmarkEntities(
            predicate: NSPredicate(format: "bookmarkedNotice.id == %d", id)
        )
    }
    
    private func fetchBookmarkEntities(
        predicate: NSPredicate? = nil,
        fetchLimit: Int = 0,
        fetchOffset: Int = 0,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) async throws -> [BookmarkEntity] {
        let context = backgroundContext
        
        return try await context.perform {
            let request = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
            request.predicate = predicate
            request.fetchLimit = fetchLimit
            request.fetchOffset = fetchOffset
            request.sortDescriptors = sortDescriptors
            
            return try context.fetch(request)
        }
    }
    
    private func createBookmarkDTOs(from entities: [BookmarkEntity]) -> [BookmarkDTO] {
        entities.map {
            return BookmarkDTO(
                notice: $0.bookmarkedNotice,
                details: $0.memo,
                alarmDate: $0.alarmDate
            )
        }
    }
    
    // MARK: - Delete
    
    func delete(by id: Int) async throws {
        try Task.checkCancellation()
        
        let context = backgroundContext
        let entities = try await fetch(withId: id)
        
        try await context.perform(schedule: .enqueued) {
            entities.forEach {
                context.delete($0)
            }
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    // MARK: - Update
    
    func update(bookmark: Bookmark) async throws {
        try Task.checkCancellation()
        
        let context = backgroundContext
        let entities = try await fetch(withId: bookmark.notice.id)
        
        try await context.perform(schedule: .enqueued) {   
            entities.forEach {
                $0.memo = bookmark.memo
                $0.alarmDate = bookmark.alarmDate
                $0.updatedAt = Date()
            }
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    func updateTimeStamp(_ update: BookmarkUpdate) async throws {
        try Task.checkCancellation()
        
        let entities = try await fetch(withId: update.bookmark.notice.id)
        
        for entity in entities {
            entity.createdAt = update.createdAt
            entity.updatedAt = update.updatedAt
        }
        
        let context = backgroundContext
        
        if context.hasChanges {
            try await context.perform(schedule: .enqueued) {
                try context.save()
            }
        }
    }
}

// MARK: - Extensions

fileprivate extension BookmarkSortOption {
    var descriptor: NSSortDescriptor {
        switch self {
        case .createdAtAscending:
            return NSSortDescriptor(key: "createdAt", ascending: true)
        case .createdAtDescending:
            return NSSortDescriptor(key: "createdAt", ascending: false)
        case .updatedAtAscending:
            return NSSortDescriptor(key: "updatedAt", ascending: true)
        case .updatedAtDescending:
            return NSSortDescriptor(key: "updatedAt", ascending: false)
        }
    }
}

extension NSPredicate: @unchecked @retroactive Sendable {}
extension NSSortDescriptor: @unchecked @retroactive Sendable {}
extension BookmarkEntity: @unchecked Sendable {}
