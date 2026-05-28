//
//  FetchReadingRoomStatusUseCase.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Foundation

public protocol FetchReadingRoomStatusUseCase {
    func execute() async throws -> [ReadingRoomStatus]
}

public struct FetchReadingRoomStatusUseCaseImpl: FetchReadingRoomStatusUseCase {
    private let repository: ReadingRoomRepository
    
    public init(repository: ReadingRoomRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [ReadingRoomStatus] {
        return try await repository.fetchReadingRoomStatus()
    }
}
