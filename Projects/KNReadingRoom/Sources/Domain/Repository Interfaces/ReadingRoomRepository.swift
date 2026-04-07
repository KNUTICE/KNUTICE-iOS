//
//  ReadingRoomRepository.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Foundation

protocol ReadingRoomRepository {
    func fetchReadingRoomStatus() async throws -> [ReadingRoomStatus]
}
