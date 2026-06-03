//
//  ReadingRoomStatus.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Foundation

public struct ReadingRoomStatus: Identifiable {
    public let id: String
    public let roomType: ReadingRoomType
    public let name: String
    public let totalSeats: Int
    public let availableSeats: Int
    public let occupiedSeats: Int
    
    public var occupancyRate: Double {
        guard totalSeats > 0 else { return 0.0 }
        return Double(occupiedSeats) / Double(totalSeats)
    }
    
    public var isFull: Bool {
        return availableSeats <= 0
    }
    
    public var congestionLevel: CongestionLevel {
        return CongestionLevel(rate: occupancyRate)
    }
    
    public init(
        id: String,
        roomType: ReadingRoomType,
        name: String,
        totalSeats: Int,
        availableSeats: Int,
        occupiedSeats: Int
    ) {
        self.id = id
        self.roomType = roomType
        self.name = name
        self.totalSeats = totalSeats
        self.availableSeats = availableSeats
        self.occupiedSeats = occupiedSeats
    }
}

public enum CongestionLevel {
    case smooth   // 원활
    case normal   // 보통
    case crowded  // 혼잡
    
    public init(rate: Double) {
        switch rate {
        case 0..<0.5:
            self = .smooth
        case 0.5..<0.8:
            self = .normal
        default:
            self = .crowded
        }
    }
    
    public var title: String {
        switch self {
        case .smooth: return "원활"
        case .normal: return "보통"
        case .crowded: return "혼잡"
        }
    }
}

public enum ReadingRoomType: String {
    case room1 = "ROOM1"
    case room2 = "ROOM2"
    case room3 = "ROOM3"
}
