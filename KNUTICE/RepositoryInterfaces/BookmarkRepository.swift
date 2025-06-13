//
//  BookmarkRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine

protocol BookmarkRepository {
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func read(page pageNum: Int, pageSize: Int) -> AnyPublisher<[Bookmark], any Error>
    func delete(by id: Int) -> AnyPublisher<Void, any Error>
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
}

extension BookmarkRepository {
    func read(page pageNum: Int, pageSize: Int = 20) -> AnyPublisher<[Bookmark], any Error> {
        return self.read(page: pageNum, pageSize: pageSize)
    }
}
