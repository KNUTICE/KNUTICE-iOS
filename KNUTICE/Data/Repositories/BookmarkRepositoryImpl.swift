//
//  BookmarkRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Factory
import Foundation
import KNUTICECore
import UserNotifications

actor BookmarkRepositoryImpl: BookmarkRepository, BookmarkCreatable {
    @Injected(\.bookmarkDataSource) private var dataSource
    
    func save(bookmark: Bookmark) async throws {
        let isExist = try await dataSource.isDuplication(id: bookmark.notice.id)
        
        guard !isExist else {
            throw ExistingBookmarkError.alreadyExist(message: "이미 존재하는 북마크에요.")
        }
        
        try await dataSource.save(bookmark)
    }
    
    func fetch(page pageNum: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        let dto = try await dataSource.fetch(page: pageNum, pageSize: pageSize, sortBy: option)
        
        return dto.compactMap {
            createBookMark(from: $0)
        }
    }
    
    func fetchWhereTimestampsAreNil() async throws -> [Bookmark] {
        let dto = try await dataSource.fetchItemsWhereTimestampsAreNil()
        
        return dto.compactMap {
            createBookMark(from: $0)
        }
    }
    
    func delete(by id: Int) async throws {
        try await dataSource.delete(by: id)
    }
    
    func update(_ bookmark: Bookmark) async throws {
        try await dataSource.update(bookmark: bookmark)
    }
    
    func updateTimeStamp(_ update: BookmarkUpdate) async throws {
        try await dataSource.updateTimeStamp(update)
    }
    
    func search(with keyword: String) async throws -> [Bookmark] {
        try Task.checkCancellation()
        
        let dtos = try await dataSource.fetch(keyword: keyword)
        
        return dtos.compactMap { dto in
            createBookMark(from: dto)
        }
    }
    
    func fetch(id: Int) async throws -> Bookmark? {
        try Task.checkCancellation()
        
        let dto = try await dataSource.fetch(withId: id)
        
        return dto.flatMap {
            createBookMark(from: $0)
        }
    }
}
