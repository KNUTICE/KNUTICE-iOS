//
//  BookmarkPersistenceStore.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/7/25.
//

import CoreData
import Foundation
import KNDomain
import KNUtility

protocol BookmarkPersistenceStore: Actor {
    /// Saves a `Bookmark` into the persistent store.
    ///
    /// This method creates both a `BookmarkEntity` and its associated `NoticeEntity`
    /// inside the given background context. The operation is performed using
    /// `.enqueued` scheduling to ensure safe, sequential writes.
    ///
    /// - Parameter bookmark: The `Bookmark` domain model to be saved.
    /// - Throws: An error if the context fails to save changes.
    func save(_ dto: BookmarkDTO) async throws
    
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
    
    /// Fetches bookmarks where either the notice title or the memo contains the specified keyword.
    ///
    /// - Parameter keyword: The search keyword to filter bookmarks by title or memo content.
    /// - Returns: An array of `BookmarkDTO` representing bookmarks that match the keyword.
    /// - Throws: An error if the fetch request fails.
    func fetch(keyword: String) async throws -> [BookmarkDTO]
    
    /// Fetches a bookmark by its unique identifier.
    ///
    /// - Parameter id: The unique identifier of the bookmark to fetch.
    /// - Returns: A `BookmarkDTO` object if found, otherwise `nil`.
    /// - Throws: An error if the task is cancelled or the fetch operation fails.
    /// - Note: Internally fetches `BookmarkEntity` objects and converts them into DTOs.
    func fetch(withId id: Int) async throws -> BookmarkDTO?
    
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
}

extension BookmarkPersistenceStore {
    func fetch(
        page: Int, pageSize: Int = 20,
        sortBy option: BookmarkSortOption
    ) async throws -> [BookmarkDTO] {
        try await self.fetch(page: page, pageSize: pageSize, sortBy: option)
    }
}

@available(iOS, deprecated: 17.0, message: "Use DeafaultBookmarkDataStore instead.")
@available(macCatalyst, deprecated: 17.0, message: "Use DeafaultBookmarkDataStore instead.")
actor BookmarkPersistenceStoreImpl: BookmarkPersistenceStore {
    static let shared: BookmarkPersistenceStoreImpl = .init()
    
    private var persistentContainer: NSPersistentContainer? = {
        let modelName: String = "Bookmark"
        
        guard let modelURL = KNDataResources.bundle.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext? = {
        persistentContainer?.newBackgroundContext()
    }()
    
    private init() {}
    
    // MARK: - Save
    
    func save(_ dto: BookmarkDTO) async throws {
        let context = backgroundContext
        
        try Task.checkCancellation()
        
        try await context?.perform(schedule: .enqueued) {
            guard let context else { throw BookmarkPersistenceError.contextUnavailable }
            
            // BookmarkEntity
            let bookmarkEntity = BookmarkEntity(context: context)
            bookmarkEntity.memo = dto.memo
            bookmarkEntity.alarmDate = dto.alarmDate
            bookmarkEntity.createdAt = Date()
            
            // NoticeEntity
            let noticeEntity = NoticeEntity(context: context)
            noticeEntity.id = Int64(dto.noticeData.nttID)
            noticeEntity.title = dto.noticeData.title
            noticeEntity.department = dto.noticeData.department
            noticeEntity.uploadDate = dto.noticeData.registrationDate
            noticeEntity.contentUrl = dto.noticeData.contentURL
            noticeEntity.isSummarizable = dto.noticeData.isContentSummary
            noticeEntity.imageUrl = dto.noticeData.contentImageURL
            noticeEntity.category = dto.noticeData.topic
            
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
        
        let entities: [BookmarkEntity] = try await fetch(withId: id)
        
        return !entities.isEmpty
    }
    
    func fetch(keyword: String) async throws -> [BookmarkDTO] {
        try Task.checkCancellation()
        
        let entities = try await fetchBookmarkEntities(
            predicate: NSPredicate(format: "bookmarkedNotice.title CONTAINS %@ OR memo CONTAINS %@", keyword, keyword)
        )
        
        return createBookmarkDTOs(from: entities)
    }
    
    func fetch(withId id: Int) async throws -> BookmarkDTO? {
        try Task.checkCancellation()
        
        let entities: [BookmarkEntity] = try await fetch(withId: id)
        
        return createBookmarkDTOs(from: entities).first
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
        guard let context = backgroundContext else {
            throw BookmarkPersistenceError.contextUnavailable
        }
        
        return try await context.perform {
            let request = BookmarkEntity.fetchRequest()
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
                noticeData: $0.noticeData,
                memo: $0.memo,
                alarmData: $0.alarmDate
            )
        }
    }
    
    // MARK: - Delete
    
    func delete(by id: Int) async throws {
        try Task.checkCancellation()
        
        let entities: [BookmarkEntity] = try await fetch(withId: id)
        
        guard let context = backgroundContext else {
            throw BookmarkPersistenceError.contextUnavailable
        }
        
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
        
        let entities: [BookmarkEntity] = try await fetch(withId: bookmark.notice.id)
        
        guard let context = backgroundContext else { throw BookmarkPersistenceError.contextUnavailable }
        
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
extension BookmarkEntity: @unchecked Sendable {
    var noticeData: NoticeData {
        let noticeEntity = bookmarkedNotice
        return NoticeData(
            nttID: Int(noticeEntity?.id ?? 0),
            title: noticeEntity?.title ?? "",
            contentURL: noticeEntity?.contentUrl ?? "",
            contentImageURL: noticeEntity?.imageUrl ?? "",
            isContentSummary: noticeEntity?.isSummarizable ?? false,
            department: noticeEntity?.department ?? "",
            registrationDate: noticeEntity?.uploadDate ?? "",
            topic: noticeEntity?.category ?? ""
        )
    }
}
