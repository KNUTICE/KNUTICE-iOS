//
//  FetchReadingRoomStatusUseCase.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Factory
import Foundation

public protocol FetchReadingRoomStatusUseCase {
    func execute() async throws -> [ReadingRoomStatus]
}

public struct FetchReadingRoomStatusUseCaseImpl: FetchReadingRoomStatusUseCase {
    @Injected(\.readingRoomRepository) private var repository

    public func execute() async throws -> [ReadingRoomStatus] {
        return try await repository.fetchReadingRoomStatus()
    }
}
