//
//  SearchNoticeAndBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Factory
import Foundation
import KNUTICECore

protocol SearchNoticeAndBookmarkUseCase: Actor {
    typealias SearchResult = Result<([Notice], [Bookmark]), any Error>
    
    /// Executes a concurrent search for both notices and bookmarks using the given keyword.
    /// - Parameter keyword: The search keyword entered by the user.
    /// - Returns: A `SearchResult` containing the fetched notices and bookmarks if successful, or a failure with the corresponding error.
    /// - Note: This method performs both fetch operations concurrently using `async let`
    ///         and checks for task cancellation before execution.
    func execute(with keyword: String) async -> SearchResult
}

actor SearchNoticeAndBookmarkUseCaseImpl: SearchNoticeAndBookmarkUseCase {
    @Injected(\.searchNoticesUseCase) private var searchNoticesUseCase
    @Injected(\.searchBookmarksUseCase) private var searchBookmarksUseCase
    
    func execute(with keyword: String) async -> SearchResult {
        do {
            try Task.checkCancellation()
            
            async let notices = searchNoticesUseCase.execute(with: keyword)
            async let bookmarks = searchBookmarksUseCase.execute(with: keyword)
            
            let results = (try await notices, try await bookmarks)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
    
}
