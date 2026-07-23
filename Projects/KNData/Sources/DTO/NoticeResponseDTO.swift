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
    let data: [NoticeItem]?
}

struct SingleNoticeResponseDTO: Decodable, Sendable {
    let metaData: MetaData
    let data: NoticeItem?
}

// MARK: - NoticeData

@available(iOS, introduced: 15.0, deprecated: 17.0, message: "Use NoticeItem instead.")
@available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "Use NoticeItem instead.")
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

// MARK: - NoticeItem

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
struct NoticeItem: Decodable, Sendable {
    let nttID: Int
    let title: String
    let contentURL: String
    let contentImageURL: String?
    let isContentSummary: Bool
    let department, registrationDate: String
    let topicIc: Int
    
    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case title
        case contentURL = "contentUrl"
        case contentImageURL = "contentImageUrl"
        case isContentSummary, department, registrationDate
        case topicIc = "topicIc"
    }
    
    init(
        nttID: Int,
        title: String,
        contentURL: String,
        contentImageURL: String?,
        isContentSummary: Bool,
        department: String,
        registrationDate: String,
        topicIc: Int
    ) {
        self.nttID = nttID
        self.title = title
        self.contentURL = contentURL
        self.contentImageURL = contentImageURL
        self.isContentSummary = isContentSummary
        self.department = department
        self.registrationDate = registrationDate
        self.topicIc = topicIc
    }
}

