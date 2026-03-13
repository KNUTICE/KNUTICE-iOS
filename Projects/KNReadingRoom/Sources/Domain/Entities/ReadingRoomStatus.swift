//
//  ReadingRoomStatus.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Foundation

struct ReadingRoomStatus: Identifiable {
    let id: String
    let roomType: ReadingRoomType
    let name: String
    let totalSeats: Int
    let availableSeats: Int
    let occupiedSeats: Int
    
    var occupancyRate: Double {
        guard totalSeats > 0 else { return 0.0 }
        return Double(occupiedSeats) / Double(totalSeats)
    }
    
    var isFull: Bool {
        return availableSeats <= 0
    }
}
