//
//  TipDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Foundation
import KNUTICECore

// MARK: - TipDTO
struct TipDTO: Decodable {
    let result: RequestResult
    let body: [TipDTOBody]?
}

// MARK: - Body
struct TipDTOBody: Decodable {
    let id, title, url, deviceType: String
    let registeredAt: String
}
