//
//  GeneralNoticeDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

// MARK: - GeneralNoticeDTO
struct ReponseDTO: Codable {
    let statusCode: Int
    let message: String
    let data: [NoticeData]
}

// MARK: - GeneralNoticeData
struct NoticeData: Codable {
    let title: String
    let nttId, contentNumber: Int
    let contentUrl: String
    let contentImage: String?
    let departName, registrationDate: String
}
