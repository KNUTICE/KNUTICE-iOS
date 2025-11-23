//
//  BookmarkRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import Foundation
import KNUTICECore

enum ReloadEvent {
    case normal
    case preserveCount
}

protocol BookmarkRepository: Sendable {
    /// A publisher that emits `ReloadEvent` whenever a bookmark-related
    /// mutation occurs (e.g., save, delete, update).
    ///
    /// Subscribers can use this publisher to automatically refresh UI or
    /// trigger data reloading in ViewModels.
    var eventPublisher: AnyPublisher<ReloadEvent, Never> { get }

    // MARK: - Create

    /// Saves a new bookmark.
    ///
    /// - Parameter bookmark: The bookmark to be stored.
    /// - Throws: An error if the bookmark already exists or if saving fails.
    func save(bookmark: Bookmark) async throws

    // MARK: - Read

    /// Fetches a paginated list of bookmarks.
    ///
    /// - Parameters:
    ///   - pageNum: The page index to load (starting from 1).
    ///   - pageSize: The number of items per page.
    ///   - option: Sorting option applied to the result set.
    /// - Returns: An array of bookmarks for the given page.
    /// - Throws: Errors from the underlying data source.
    func fetch(
        page pageNum: Int,
        pageSize: Int,
        sortBy option: BookmarkSortOption
    ) async throws -> [Bookmark]

    /// Fetches all bookmarks whose timestamp values are `nil`.
    ///
    /// Typically used for migration, synchronization, or first-run logic.
    ///
    /// - Returns: An array of bookmarks missing timestamps.
    /// - Throws: Errors from the underlying data source.
    func fetchWhereTimestampsAreNil() async throws -> [Bookmark]
    
    /// Fetches a single bookmark by its ID.
    ///
    /// - Parameter id: The identifier of the bookmark.
    /// - Returns: The bookmark if it exists, or `nil` otherwise.
    /// - Throws: Errors from the underlying data source.
    func fetch(id: Int) async throws -> Bookmark?

    // MARK: - Delete

    /// Deletes a bookmark by its unique identifier.
    ///
    /// - Parameter id: The bookmark's identifier.
    /// - Throws: Errors if the deletion fails.
    func delete(by id: Int) async throws

    // MARK: - Update

    /// Updates an existing bookmark.
    ///
    /// - Parameter bookmark: The bookmark containing the updated values.
    /// - Throws: Errors if the update cannot be performed.
    func update(_ bookmark: Bookmark) async throws

    /// Updates the timestamp-related fields of a bookmark.
    ///
    /// - Parameter update: A value object containing timestamp changes.
    /// - Throws: Errors from the underlying data source.
    func updateTimeStamp(_ update: BookmarkUpdate) async throws

    // MARK: - Search

    /// Searches bookmarks with a matching keyword.
    ///
    /// - Parameter keyword: The text to search for.
    /// - Returns: A list of bookmarks whose fields match the keyword.
    /// - Throws: Errors if the search operation fails.
    func search(with keyword: String) async throws -> [Bookmark]
}
