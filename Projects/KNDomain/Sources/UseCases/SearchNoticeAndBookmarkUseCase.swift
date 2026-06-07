//
//  SearchNoticeAndBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Foundation

public protocol SearchNoticeAndBookmarkUseCase: Sendable {
    typealias SearchResult = Result<([NoticeSnapshot], [Bookmark]), any Error>
    
    /// Executes a concurrent search for both notices and bookmarks using the given keyword.
    /// - Parameter keyword: The search keyword entered by the user.
    /// - Returns: A `SearchResult` containing the fetched notices and bookmarks if successful, or a failure with the corresponding error.
    /// - Note: This method performs both fetch operations concurrently using `async let`
    ///         and checks for task cancellation before execution.
    func execute(with keyword: String) async -> SearchResult
}

public final class SearchNoticeAndBookmarkUseCaseImpl: SearchNoticeAndBookmarkUseCase {
    private let searchNoticesUseCase: SearchNoticeSnapshotsUseCase
    private let searchBookmarksUseCase: SearchBookmarksUseCase
    
    public init(
        searchNoticesUseCase: SearchNoticeSnapshotsUseCase,
        searchBookmarksUseCase: SearchBookmarksUseCase
    ) {
        self.searchNoticesUseCase = searchNoticesUseCase
        self.searchBookmarksUseCase = searchBookmarksUseCase
    }
    
    public func execute(with keyword: String) async -> SearchResult {
        do {
            try Task.checkCancellation()
            
            async let noticeSnapshots = searchNoticesUseCase.execute(with: keyword)
            async let bookmarks = searchBookmarksUseCase.execute(with: keyword)
            
            let results = (try await noticeSnapshots, try await bookmarks)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
    
}
