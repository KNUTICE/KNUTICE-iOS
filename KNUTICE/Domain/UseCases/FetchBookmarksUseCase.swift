//
//  FetchBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Factory
import Foundation
import KNUTICECore

protocol FetchBookmarksUseCase: Actor {
    
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

extension FetchBookmarksUseCase {
    
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

actor FetchBookmarksUseCaseImpl: FetchBookmarksUseCase {
    @Injected(\.bookmarkRepository) private var bookmarkRepository
    
    /// Fetches bookmark data, ensuring that timestamp fields (`createdAt`, `updatedAt`)
    /// are initialized for legacy bookmark entries that may lack these values.
    ///
    /// Process Overview:
    /// 1. If timestamps are already updated (based on a stored flag), it simply returns paginated data.
    /// 2. Otherwise, it:
    ///    - Retrieves all bookmarks missing timestamp fields.
    ///    - Derives the timestamps using the associated notice’s upload date.
    ///    - Updates each bookmark asynchronously using a task group.
    ///    - Persists a flag so this migration step does not repeat.
    /// 3. Finally, returns the fully updated and sorted bookmark list.
    ///
    /// - Parameters:
    ///   - page: The page index to load.
    ///   - pageSize: Maximum number of bookmarks to return.
    ///   - option: Sorting option applied to the final bookmark set.
    /// - Returns: A list of bookmarks reflecting updated timestamp fields and appropriate pagination.
    /// - Throws: An error if any migration or fetching operation fails.
    func execute(page: Int, pageSize: Int = 20, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isBookmarkTimestampUpdated.rawValue) else {
            return try await bookmarkRepository.fetch(page: page, pageSize: pageSize, sortBy: option)
        }
        
        // createdAt 필드가 nil인 모든 Bookmark 데이터를 가져옴
        let incompleteBookmarks = try await bookmarkRepository.fetchWhereTimestampsAreNil()
        let updates = incompleteBookmarks.map {
            let timestamp = $0.notice.uploadDate.toDate() ?? Date()
            
            return BookmarkUpdate(
                bookmark: $0,
                createdAt: timestamp,
                updatedAt: timestamp
            )
        }
        
        // updatedAt, createdAt 필드 업데이트
        try await withThrowingTaskGroup { group in
            for update in updates {
                group.addTask {
                    try await self.bookmarkRepository.updateTimeStamp(update)
                }
            }
            
            try await group.waitForAll()
        }
        
        // timestamp update flag 값을 true로 변경
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isBookmarkTimestampUpdated.rawValue)
        
        // 업데이트 된 Bookmark 조회
        return try await bookmarkRepository.fetch(page: page, pageSize: pageSize, sortBy: option)
    }
    
    /// Fetches a single bookmark using its unique identifier.
    ///
    /// - Parameter id: The ID of the bookmark to retrieve.
    /// - Returns: The corresponding bookmark, or `nil` if no match is found.
    /// - Throws: An error if an underlying repository error occurs.
    func execute(for id: Int) async throws -> Bookmark? {
        return try await bookmarkRepository.fetch(id: id)
    }
}

fileprivate extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return dateFormatter.date(from: self)
    }
}
