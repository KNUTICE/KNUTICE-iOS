//
//  FetchReadingRoomStatusUseCase.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Factory
import Foundation

protocol FetchReadingRoomStatusUseCase {
    func execute() async throws -> [ReadingRoomStatus]
}

struct FetchReadingRoomStatusUseCaseImpl: FetchReadingRoomStatusUseCase {
    @Injected(\.readingRoomRepository) private var repository

    func execute() async throws -> [ReadingRoomStatus] {
        return try await repository.fetchReadingRoomStatus()
    }
}
