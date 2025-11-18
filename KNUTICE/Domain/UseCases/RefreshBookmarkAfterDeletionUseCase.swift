//
//  RefreshBookmarkAfterDeletionUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/25.
//

import Factory
import Foundation
import KNUTICECore

protocol RefreshBookmarkAfterDeletionUseCase: Actor {
    /// Deletes the given bookmark and fetches an updated list of bookmarks.
    ///
    /// - Parameters:
    ///   - bookmark: The bookmark to delete.
    ///   - reloadCount: The maximum number of bookmarks to re-fetch after deletion.
    ///   - option: The sorting option applied when reloading the bookmarks.
    /// - Returns: A list of bookmarks reflecting the updated state.
    /// - Throws: An error if deletion or fetching fails.
    func execute(
        deletion bookmark: Bookmark,
        reloadCount: Int,
        sortBy option: BookmarkSortOption
    ) async throws -> [Bookmark]
}

actor RefreshBookmarkAfterDeletionUseCaseImpl: RefreshBookmarkAfterDeletionUseCase {
    @Injected(\.deleteBookmarkUseCase) private var deleteBookmarkUseCase
    @Injected(\.bookmarkRepository) private var bookmarkRepository: BookmarkRepository

    /// Performs the following sequence:
    /// 1. Deletes the given bookmark using `deleteBookmarkUseCase`.
    /// 2. Fetches an updated list of bookmarks from the repository,
    ///    limited by `reloadCount` and sorted using the provided option.
    ///
    /// - Parameters:
    ///   - bookmark: The bookmark to delete.
    ///   - reloadCount: The number of bookmarks to load after deletion.
    ///   - option: The sorting rule applied when fetching updated bookmarks.
    /// - Returns: A refreshed array of bookmarks reflecting the latest state.
    /// - Throws: An error if bookmark deletion or data fetching fails.
    func execute(
        deletion bookmark: KNUTICECore.Bookmark,
        reloadCount: Int,
        sortBy option: BookmarkSortOption
    ) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        // Bookmark 삭제
        try await deleteBookmarkUseCase.execute(for: bookmark)
        
        // Bookmark 삭제 후, 갱신을 위해 나머지 데이터 가져오기
        return try await bookmarkRepository.fetch(page: 0, pageSize: reloadCount, sortBy: option)
    }
    
}
