//
//  GeneralNoticeDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

// MARK: - GeneralNoticeDTO
struct GeneralNoticeDTO: Codable {
    let statusCode: Int
    let message: String
    let data: [GeneralNoticeData]
}

// MARK: - GeneralNoticeData
struct GeneralNoticeData: Codable {
    let title: String
    let nttId, boardNumber: Int
    let contentURL: String
    let contentImage: String?
    let departName, registrationDate: String
}
