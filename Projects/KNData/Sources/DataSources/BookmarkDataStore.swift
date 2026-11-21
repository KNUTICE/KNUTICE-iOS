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
    func save(_ bookmark: StoredBookmark) throws
    
    func fetch(
        sortBy option: BookmarkSortOption,
        fetchLimit limit: Int?,
        fetchOffset offset: Int
    ) throws -> [StoredBookmark]
    
    func fetch(
        keyword: String,
        fetchLimit limit: Int?,
        fetchOffset offset: Int
    ) throws -> [StoredBookmark]
    
    func fetch(id: Int) throws -> StoredBookmark?
    
    func delete(id: Int) throws
    
    func update(id: Int, memo: String, alarmDate: Date?) throws
}

extension BookmarkManageable {
    func fetch(
        sortBy option: BookmarkSortOption,
        fetchLimit limit: Int? = nil,
        fetchOffset offset: Int = 0
    ) throws -> [StoredBookmark] {
        try self.fetch(sortBy: option, fetchLimit: limit, fetchOffset: offset)
    }
}

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
@ModelActor
actor BookmarkDataStore: BookmarkManageable {
    static let shared: BookmarkDataStore = {
        do {
            let modelContainer = try ModelContainer(for: BookmarkModel.self)
            return BookmarkDataStore(modelContainer: modelContainer)
        } catch {
            fatalError("Failed to create BookmarkDataStore: \(error)")
        }
    }()
    
    // MARK: - Save
    
    /// Inserts a bookmark into the SwiftData context and persists the pending changes.
    ///
    /// - Parameter bookmark: A value containing the bookmark and notice data to store.
    /// - Throws: An error if SwiftData fails to save the context.
    func save(_ bookmark: StoredBookmark) throws {
        guard try fetchModel(id: bookmark.notice.id) == nil else {
            throw ExistingBookmarkError.alreadyExist(message: "이미 존재하는 북마크에요.")
        }

        modelContext.insert(bookmark.asModel)
        
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    // MARK: - Fetch
    
    /// Fetches bookmarks from SwiftData using the provided sort option.
    ///
    /// - Parameters:
    ///   - option: The sort option used to order the fetched bookmarks.
    ///   - limit: The maximum number of bookmarks to fetch, or nil for no limit.
    ///   - offset: The number of matching bookmarks to skip before fetching.
    /// - Returns: Sendable snapshots of bookmarks matching the requested sort order.
    /// - Throws: An error if SwiftData fails to fetch the bookmarks.
    func fetch(
        sortBy option: BookmarkSortOption,
        fetchLimit limit: Int? = nil,
        fetchOffset offset: Int = 0
    ) throws -> [StoredBookmark] {
        var descriptor = FetchDescriptor<BookmarkModel>(sortBy: [option.sortDescriptor])
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset
        
        return try modelContext.fetch(descriptor).map(\.asStoredBookmark)
    }
    
    /// Fetches bookmarks whose memo or notice title contains the given keyword.
    ///
    /// - Parameters:
    ///   - keyword: The search text used to filter bookmark memos and notice titles.
    ///   - limit: The maximum number of bookmarks to fetch, or nil for no limit.
    ///   - offset: The number of matching bookmarks to skip before fetching.
    /// - Returns: Sendable snapshots of bookmarks matching the keyword.
    /// - Throws: An error if SwiftData fails to fetch the bookmarks.
    func fetch(
        keyword: String,
        fetchLimit limit: Int? = nil,
        fetchOffset offset: Int = 0
    ) throws -> [StoredBookmark] {
        let predicate = #Predicate<BookmarkModel> { $0.memo.contains(keyword) || $0.notice.title.contains(keyword) }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset
        
        return try modelContext.fetch(descriptor).map(\.asStoredBookmark)
    }
    
    /// Fetches the bookmark that matches the given identifier.
    ///
    /// - Parameter id: The unique identifier of the bookmark to fetch.
    /// - Returns: A snapshot of the matching bookmark, or `nil` if it does not exist.
    /// - Throws: An error if SwiftData fails to fetch the bookmark.
    func fetch(id: Int) throws -> StoredBookmark? {
        try fetchModel(id: id)?.asStoredBookmark
    }
    
    private func fetchModel(id: Int) throws -> BookmarkModel? {
        let predicate = #Predicate<BookmarkModel> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try modelContext.fetch(descriptor).first
    }
    
    // MARK: - Delete
    
    /// Deletes the bookmark that matches the given identifier.
    ///
    /// - Parameter id: The unique identifier of the bookmark to delete.
    /// - Throws: An error if SwiftData fails to fetch or delete the bookmark.
    func delete(id: Int) throws {
        guard let bookmark = try fetchModel(id: id) else { return }
        
        modelContext.delete(bookmark)
        
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    // MARK: - Update
    
    /// Updates the stored bookmark that matches the given bookmark's identifier.
    ///
    /// - Parameters:
    ///   - id: The notice ID of the bookmark to update.
    ///   - memo: The latest memo.
    ///   - alarmDate: The latest alarm date.
    /// - Throws: An error if SwiftData fails to fetch or save the bookmark.
    func update(id: Int, memo: String, alarmDate: Date?) throws {
        guard let existingBookmark = try fetchModel(id: id) else { return }

        existingBookmark.memo = memo
        existingBookmark.alarmDate = alarmDate
        existingBookmark.updatedAt = Date()
        
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
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

fileprivate extension BookmarkModel {
    var asStoredBookmark: StoredBookmark {
        StoredBookmark(
            notice: notice.asStoredNotice,
            memo: memo,
            alarmDate: alarmDate
        )
    }
}

fileprivate extension NoticeModel {
    var asStoredNotice: StoredNotice {
        StoredNotice(
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

fileprivate extension StoredBookmark {
    var asModel: BookmarkModel {
        BookmarkModel(
            notice: NoticeModel(
                id: notice.id,
                title: notice.title,
                contentURL: notice.contentURL,
                isSummarizable: notice.isSummarizable,
                department: notice.department,
                uploadDate: notice.uploadDate,
                imageURL: notice.imageURL,
                topicId: notice.topicId
            ),
            memo: memo,
            alarmDate: alarmDate
        )
    }
}
