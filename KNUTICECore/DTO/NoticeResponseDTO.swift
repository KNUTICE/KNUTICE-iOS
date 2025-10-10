//
//  NoticeResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

// MARK: - NoticeReponseDTO
public struct NoticeResponseDTO: Decodable, Sendable {
    public let metaData: MetaData
    public let data: [NoticeData]?
}

public struct SingleNoticeResponseDTO: Decodable, Sendable {
    public let metaData: MetaData
    public let data: NoticeData?
}

// MARK: - Datum
public struct NoticeData: Decodable, Sendable {
    public let nttID: Int
    public let title: String
    public let contentURL: String
    public let contentImageURL: String?
    public let department, registrationDate: String
    public let topic: String

    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case title
        case contentURL = "contentUrl"
        case contentImageURL = "contentImageUrl"
        case department, registrationDate, topic
    }
}
