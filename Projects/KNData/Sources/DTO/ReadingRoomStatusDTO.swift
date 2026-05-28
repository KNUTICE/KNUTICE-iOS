//
//  ReadingRoomStatusDTO.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Foundation
import KNDomain
import KNUtility

// MARK: - ReadingRoomStatusDTO
struct ReadingRoomStatusDTO: Decodable {
    let metaData: MetaData
    let data: [ReadingRoomStatusData]
    
    var toDomain: [ReadingRoomStatus] {
        return data.map { $0.toDomain }
    }
}

// MARK: - Datum
struct ReadingRoomStatusData: Decodable {
    let roomID, roomName: String
    let totalSeat, availableSeat, occupiedSeat, rowCount: Int
    let columnCount: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case roomName, totalSeat, availableSeat, occupiedSeat, rowCount, columnCount
    }
    
    var toDomain: ReadingRoomStatus {
        return ReadingRoomStatus(
            id: roomID,
            roomType: ReadingRoomType(rawValue: roomID) ?? .room1,
            name: roomName,
            totalSeats: totalSeat,
            availableSeats: availableSeat,
            occupiedSeats: occupiedSeat
        )
    }
}
