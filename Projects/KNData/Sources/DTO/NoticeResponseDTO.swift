//
//  NoticeResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation
import KNUtility

// MARK: - NoticeReponseDTO
struct NoticeResponseDTO: Decodable, Sendable {
    let metaData: MetaData
    let data: [NoticeData]?
}

struct SingleNoticeResponseDTO: Decodable, Sendable {
    let metaData: MetaData
    let data: NoticeData?
}

// MARK: - NoticeData
struct NoticeData: Decodable, Sendable {
    let nttID: Int
    let title: String
    let contentURL: String
    let contentImageURL: String?
    let isContentSummary: Bool
    let department, registrationDate: String
    let topic: String

    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case title
        case contentURL = "contentUrl"
        case contentImageURL = "contentImageUrl"
        case isContentSummary, department, registrationDate, topic
    }
    
    init(
        nttID: Int,
        title: String,
        contentURL: String,
        contentImageURL: String?,
        isContentSummary: Bool,
        department: String,
        registrationDate: String,
        topic: String
    ) {
        self.nttID = nttID
        self.title = title
        self.contentURL = contentURL
        self.contentImageURL = contentImageURL
        self.isContentSummary = isContentSummary
        self.department = department
        self.registrationDate = registrationDate
        self.topic = topic
    }
}
