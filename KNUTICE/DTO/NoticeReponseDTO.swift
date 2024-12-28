//
//  NoticeReponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

// MARK: - NoticeReponseDTO
struct NoticeReponseDTO: Decodable {
    let result: RequestResult
    let body: [NoticeReponseBody]?
}

// MARK: - Body
struct NoticeReponseBody: Decodable {
    let nttID, contentNumber: Int
    let title: String
    let contentURL: String
    let contentImage: String?
    let departName, registeredAt: String

    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case contentNumber, title
        case contentURL = "contentUrl"
        case contentImage, departName, registeredAt
    }
}
