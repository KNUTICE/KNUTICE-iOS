//
//  BookmarkRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import Foundation
import KNUTICECore

protocol BookmarkRepository {
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func read(page pageNum: Int, pageSize: Int, sortBy option: BookmarkSortOption) -> AnyPublisher<[Bookmark], any Error>
    func fetchWhereTimestampsAreNil() -> AnyPublisher<[Bookmark], any Error>
    func delete(by id: Int) -> AnyPublisher<Void, any Error>
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func update(_ updates: [BookmarkUpdate]) -> AnyPublisher<Void, any Error>
    func search(with keyword: String) async throws -> [Bookmark]
}
