//
//  FetchBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Foundation
import KNUtility

public protocol FetchBookmarksUseCase: Sendable {
    
    /// Fetches a list of bookmarks for a given page, page size, and sort option.
    ///
    /// - Parameters:
    ///   - page: The page index to load.
    ///   - pageSize: The number of items per page.
    ///   - option: The sorting option applied to the resulting list.
    /// - Returns: A slice of bookmark data sorted and paginated accordingly.
    /// - Throws: An error if the repository fetch operation fails.
    func execute(page: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark]
    
    /// Fetches a single bookmark by its identifier.
    ///
    /// - Parameter id: The unique identifier of the bookmark to retrieve.
    /// - Returns: A bookmark matching the identifier, or `nil` if not found.
    /// - Throws: An error if the repository fetch operation fails.
    func execute(for id: Int) async throws -> Bookmark?
}

public extension FetchBookmarksUseCase {
    
    /// A convenience overload that applies a default page size.
    ///
    /// - Parameters:
    ///   - page: The page index to load.
    ///   - pageSize: The number of items per page (default: 20).
    ///   - option: The sorting option applied to the resulting list.
    /// - Returns: A slice of bookmark data.
    /// - Throws: An error if the repository fetch operation fails.
    func execute(page: Int, pageSize: Int = 20, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        try await self.execute(page: page, pageSize: pageSize, sortBy: option)
    }
}

public final class FetchBookmarksUseCaseImpl: FetchBookmarksUseCase {
    private let bookmarkRepository: BookmarkRepository
    private let topicRepository: TopicRepository
    
    public init(
        bookmarkReportory: BookmarkRepository,
        topicRepository: TopicRepository
    ) {
        self.bookmarkRepository = bookmarkReportory
        self.topicRepository = topicRepository
    }
    
    /// Fetches bookmarked notices using the specified pagination and sorting options.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - pageSize: The number of bookmarks to fetch per page. Defaults to `20`.
    ///   - option: The sorting option used to order the bookmarks.
    /// - Returns: A list of bookmarks matching the specified criteria.
    /// - Throws: A `CancellationError` if the task is cancelled, or an error thrown by the repository.
    public func execute(
        page: Int,
        pageSize: Int = 20,
        sortBy option: BookmarkSortOption
    ) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        // 북마크 목록을 가져온 뒤, department 정보가 없는 항목만 보완
        let bookmarks = try await bookmarkRepository.fetch(page: page, pageSize: pageSize, sortBy: option)
        var updatedBookmarks = [Bookmark]()
        
        try await withThrowingTaskGroup(of: Bookmark.self) { group in
            for bookmark in bookmarks {
                if bookmark.notice.department != nil {
                    group.addTask {
                        return bookmark
                    }
                } else {
                    group.addTask {
                        // topic 조회 결과가 없으면 원본 북마크를 그대로 유지
                        let topic = try await self.topicRepository.getTopics(id: bookmark.notice.topicId)
                        
                        guard let department = topic.first?.localizedDescription else {
                            return bookmark
                        }
                        
                        return bookmark.withDepartmentIfNeeded(department)
                    }
                }
            }
            
            for try await bookmark in group {
                updatedBookmarks.append(bookmark)
            }
        }
        
        return updatedBookmarks
    }
    
    /// Fetches a single bookmark using its unique identifier.
    ///
    /// - Parameter id: The ID of the bookmark to retrieve.
    /// - Returns: The corresponding bookmark, or `nil` if no match is found.
    /// - Throws: An error if an underlying repository error occurs.
    public func execute(for id: Int) async throws -> Bookmark? {
        try Task.checkCancellation()
        
        // 북마크가 없거나 이미 학과 정보가 있으면 그대로 반환
        guard let bookmark = try await bookmarkRepository.fetch(id: id) else { return nil }
        guard bookmark.notice.department == nil else { return bookmark }
        
        // 학과 정보가 비어 있으면 topic 정보로 보완
        let topic = try await topicRepository.getTopics(id: bookmark.notice.topicId)
        guard let department = topic.first?.localizedDescription else { return bookmark }
        
        return bookmark.withDepartmentIfNeeded(department)
    }
}
