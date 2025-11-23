//
//  BookmarkRepositoryTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/8/25.
//

import KNUTICECore
import Testing
@testable import KNUTICE

@Suite(.serialized)
struct BookmarkRepositoryTests {
    private var repository: BookmarkRepository
    
    init() {
        repository = BookmarkRepositoryImpl.shared
    }

    @Test(arguments: [
        Bookmark.sample
    ])
    func save(bookmark: Bookmark) async throws {
        try await repository.save(bookmark: bookmark)
        
        #expect(true)
    }

    @Test
    func fetch() async throws {
        let bookmarks = try await repository.fetch(page: 0, pageSize: 0, sortBy: .createdAtAscending)
        
        #expect(!bookmarks.isEmpty)
    }
    
    @Test(arguments: [
        Bookmark.sample
    ])
    func update(bookmark: Bookmark) async throws {
        try await repository.update(bookmark)
        
        #expect(true)
    }
    
    @Test(arguments: [
        Bookmark.sample
    ])
    func delete(bookmark: Bookmark) async throws {
        try await repository.delete(by: bookmark.identity)
    }
}
