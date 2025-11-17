//
//  SearchBookmarkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Factory
import Foundation
import KNUTICECore

protocol SearchBookmarksUseCase: Actor {
    func execute(with keyword: String) async throws -> [Bookmark]
}

actor SearchBookmarksUseCaseImpl: SearchBookmarksUseCase {
    @Injected(\.bookmarkRepository) private var repository
    
    func execute(with keyword: String) async throws -> [KNUTICECore.Bookmark] {
        return try await repository.search(with: keyword)
    }
    
}
