//
//  ReadingRoomRepository.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Foundation

public protocol ReadingRoomRepository {
    func fetchReadingRoomStatus() async throws -> [ReadingRoomStatus]
}
