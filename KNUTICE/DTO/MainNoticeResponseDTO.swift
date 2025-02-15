//
//  MainNoticeDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import Foundation

// MARK: - MainNoticeDTO
struct MainNoticeResponseDTO: Decodable {
    let result: RequestResult
    let body: MainNoticeResponseBody
}

// MARK: - Body
struct MainNoticeResponseBody: Decodable {
    let latestThreeGeneralNews, latestThreeScholarshipNews, latestThreeEventNews, latestThreeAcademicNews: [LatestThreeNews]
}

// MARK: - LatestThreeNew
struct LatestThreeNews: Decodable {
    let nttID: Int
    let title, contentURL, departmentName, registeredAt: String

    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case title
        case contentURL = "contentUrl"
        case departmentName, registeredAt
    }
}
