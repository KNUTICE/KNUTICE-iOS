//
//  SearchBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Factory
import Foundation

protocol SearchBookmarksUseCase: Actor {
    func execute(with keyword: String) async throws -> [Bookmark]
}

actor SearchBookmarksUseCaseImpl: SearchBookmarksUseCase {
    @Injected(\.bookmarkRepository) private var repository
    
    func execute(with keyword: String) async throws -> [Bookmark] {
        return try await repository.search(with: keyword)
    }
    
}
