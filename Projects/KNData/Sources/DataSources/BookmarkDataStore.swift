//
//  BookmarkDataStore.swift
//  KNData
//
//  Created by 이정훈 on 7/9/26.
//

import Foundation
import KNDomain
import KNUtility
import SwiftData

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
protocol BookmarkManageable: Actor {
    func save(
        _ bookmark: Bookmark
    ) throws
    
    func fetch(
        sortBy option: BookmarkSortOption,
        fetchLimit limit: Int,
        fetchOffset offset: Int
    ) throws -> [Bookmark]
    
    func fetch(
        keyword: String,
        fetchLimit limit: Int,
        fetchOffset offset: Int
    ) throws -> [Bookmark]
    
    func fetch(
        id: Int
    ) throws -> Bookmark?
    
    func delete(
        id: Int
    ) throws
    
    func update(
        _ bookmark: Bookmark
    ) throws
}

extension BookmarkManageable {
    func fetch(
        sortBy option: BookmarkSortOption,
        fetchLimit limit: Int = 20,
        fetchOffset offset: Int = 0
    ) throws -> [Bookmark] {
        try self.fetch(sortBy: option, fetchLimit: limit, fetchOffset: offset)
    }
}

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
actor BookmarkDataStore: BookmarkManageable {
    static let shared: BookmarkDataStore = {
        do {
            return try BookmarkDataStore()
        } catch {
            fatalError("Failed to create BookmarkDataStore: \(error)")
        }
    }()
    
    private let modelContext: ModelContext
    
    private init() throws {
        let modelContainer = try ModelContainer(for: BookmarkModel.self)
        modelContext = ModelContext(modelContainer)
    }
    
    // MARK: - Save
    
    /// Inserts a bookmark into the SwiftData context and persists the pending changes.
    ///
    /// - Parameter bookmark: The bookmark model to store.
    /// - Throws: An error if SwiftData fails to save the context.
    func save(
        _ bookmark: Bookmark
    ) throws {
        let bookmarkModel = bookmark.asModel
        modelContext.insert(bookmarkModel)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    // MARK: - Fetch
    
    /// Fetches bookmarks from SwiftData using the provided sort option.
    ///
    /// - Parameters:
    ///   - option: The sort option used to order the fetched bookmarks.
    ///   - limit: The maximum number of bookmarks to fetch.
    ///   - offset: The number of matching bookmarks to skip before fetching.
    /// - Returns: A list of bookmarks matching the requested sort order.
    /// - Throws: An error if SwiftData fails to fetch the bookmarks.
    func fetch(
        sortBy option: BookmarkSortOption,
        fetchLimit limit: Int = 20,
        fetchOffset offset: Int = 0
    ) throws -> [Bookmark] {
        var descriptor = FetchDescriptor<BookmarkModel>(sortBy: [option.sortDescriptor])
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset
        
        return try modelContext.fetch(descriptor).map(\.asEntity)
    }
    
    /// Fetches bookmarks whose memo or notice title contains the given keyword.
    ///
    /// - Parameters:
    ///   - keyword: The search text used to filter bookmark memos and notice titles.
    ///   - limit: The maximum number of bookmarks to fetch.
    ///   - offset: The number of matching bookmarks to skip before fetching.
    /// - Returns: A list of bookmarks matching the keyword.
    /// - Throws: An error if SwiftData fails to fetch the bookmarks.
    func fetch(
        keyword: String,
        fetchLimit limit: Int = 20,
        fetchOffset offset: Int = 0
    ) throws -> [Bookmark] {
        let predicate = #Predicate<BookmarkModel> { $0.memo.contains(keyword) || $0.notice.title.contains(keyword) }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset
        
        return try modelContext.fetch(descriptor).map(\.asEntity)
    }
    
    /// Fetches the bookmark that matches the given identifier.
    ///
    /// - Parameter id: The unique identifier of the bookmark to fetch.
    /// - Returns: The matching bookmark, or `nil` if no bookmark exists for the identifier.
    /// - Throws: An error if SwiftData fails to fetch the bookmark.
    func fetch(
        id: Int
    ) throws -> Bookmark? {
        try fetchModel(id: id)?.asEntity
    }
    
    private func fetchModel(
        id: Int
    ) throws -> BookmarkModel? {
        let predicate = #Predicate<BookmarkModel> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try modelContext.fetch(descriptor).first
    }
    
    // MARK: - Delete
    
    /// Deletes the bookmark that matches the given identifier.
    ///
    /// - Parameter id: The unique identifier of the bookmark to delete.
    /// - Throws: An error if SwiftData fails to fetch or delete the bookmark.
    func delete(
        id: Int
    ) throws {
        guard let bookmark = try fetchModel(id: id) else { return }
        
        modelContext.delete(bookmark)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    // MARK: - Update
    
    /// Updates the stored bookmark that matches the given bookmark's identifier.
    ///
    /// - Parameter bookmark: The bookmark containing the latest memo and alarm date values.
    /// - Throws: An error if SwiftData fails to fetch or save the bookmark.
    func update(
        _ bookmark: Bookmark
    ) throws {
        guard let existingBookmark = try fetchModel(id: bookmark.notice.id) else { return }

        existingBookmark.memo = bookmark.memo
        existingBookmark.alarmDate = bookmark.alarmDate
        existingBookmark.updatedAt = Date()
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
}

fileprivate extension Bookmark {
    var asModel: BookmarkModel {
        BookmarkModel(
            notice: notice,
            memo: memo,
            alarmDate: alarmDate
        )
    }
}

fileprivate extension BookmarkSortOption {
    /// Converts the bookmark sort option into a SwiftData sort descriptor.
    var sortDescriptor: SortDescriptor<BookmarkModel> {
        switch self {
        case .createdAtAscending:
            return SortDescriptor(\.createdAt, order: .forward)
        case .createdAtDescending:
            return SortDescriptor(\.createdAt, order: .reverse)
        case .updatedAtAscending:
            return SortDescriptor(\.updatedAt, order: .forward)
        case .updatedAtDescending:
            return SortDescriptor(\.updatedAt, order: .reverse)
        }
    }
}
