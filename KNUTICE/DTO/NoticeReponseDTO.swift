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

struct SingleNoticeResponseDTO: Decodable {
    let result: RequestResult
    let body: NoticeReponseBody?
}

// MARK: - Body
struct NoticeReponseBody: Decodable {
    let nttID: Int
    let title: String
    let contentURL: String
    let contentImage: String?
    let departmentName, registeredAt, noticeName: String

    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case title
        case contentURL = "contentUrl"
        case contentImage, departmentName, registeredAt, noticeName
    }
}
