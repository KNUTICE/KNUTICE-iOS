//
//  BookmarkRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine

protocol BookmarkRepository {
    func save(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func read(delay: Int) -> AnyPublisher<[Bookmark], any Error>
}
