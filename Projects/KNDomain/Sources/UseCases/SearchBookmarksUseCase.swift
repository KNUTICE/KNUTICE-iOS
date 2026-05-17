//
//  SearchBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Factory
import Foundation

public protocol SearchBookmarksUseCase: Actor {
    func execute(with keyword: String) async throws -> [Bookmark]
}

public actor SearchBookmarksUseCaseImpl: SearchBookmarksUseCase {
    private let repository: BookmarkRepository
    
    public init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    public func execute(with keyword: String) async throws -> [Bookmark] {
        return try await repository.search(with: keyword)
    }
    
}
