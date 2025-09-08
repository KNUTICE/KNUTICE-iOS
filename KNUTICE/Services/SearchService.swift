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
    func search(with keyword: String) async -> SearchResult
}

// MARK: - implementation
actor SearchServiceImpl: SearchService {
    @Injected(\.searchRepository) private var searchRepository
    @Injected(\.bookmarkRepository) private var bookmarkRepository
    
    func search(with keyword: String) async -> SearchResult {
        do {
            try Task.checkCancellation()
            
            async let notices = searchRepository.search(with: keyword)
            async let bookmarks = bookmarkRepository.search(with: keyword)
            
            let results = (try await notices, try await bookmarks)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}
