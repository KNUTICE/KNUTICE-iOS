//
//  TipResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Foundation
import KNUTICECore

// MARK: - TipResponseDTO
struct TipResponseDTO: Decodable, Sendable {
    let metaData: MetaData
    let data: [TipData]?
}

// MARK: - TipData
struct TipData: Codable {
    let tipID, title, url, deviceType: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case tipID = "tipId"
        case title, url, deviceType, createdAt
    }
}
