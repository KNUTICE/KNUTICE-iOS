//
//  SearchService.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/3/25.
//

import Factory
import Foundation
import KNUTICECore

// MARK: - Typealias
typealias SearchResult = Result<([Notice], [Bookmark]), any Error>

// MARK: - Protocol
protocol SearchService: Actor {
    /// Searches notices and bookmarks concurrently using the given keyword.
    ///
    /// This method performs a parallel search by querying both the `noticeRepository`
    /// and the `bookmarkRepository` with the provided keyword. The results are combined
    /// and returned as a `SearchResult`.
    ///
    /// - Important: This method checks for task cancellation before performing the search.
    ///
    /// - Parameter keyword: The search keyword used to query both notices and bookmarks.
    ///
    /// - Returns: A `SearchResult` value containing either the tuple of matching notices and bookmarks on success,
    ///   or a failure with the corresponding error.
    func search(with keyword: String) async -> SearchResult
}

// MARK: - implementation
actor SearchServiceImpl: SearchService {
    @Injected(\.noticeRepository) private var noticeRepository
    @Injected(\.bookmarkRepository) private var bookmarkRepository
    
    func search(with keyword: String) async -> SearchResult {
        do {
            try Task.checkCancellation()
            
            async let notices = noticeRepository.fetchNotices(keyword: keyword)
            async let bookmarks = bookmarkRepository.search(with: keyword)
            
            let results = (try await notices, try await bookmarks)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}
