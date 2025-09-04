//
//  NoticeReponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

// MARK: - NoticeReponseDTO
public struct NoticeReponseDTO: Decodable {
    public let result: RequestResult
    public let body: [NoticeReponseBody]?
}

public struct SingleNoticeResponseDTO: Decodable {
    public let result: RequestResult
    public let body: NoticeReponseBody?
}

// MARK: - Body
public struct NoticeReponseBody: Decodable {
    public let nttID: Int
    public let title: String
    public let contentURL: String
    public let contentImage: String?
    public let departmentName, registeredAt, noticeName: String

    public enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case title
        case contentURL = "contentUrl"
        case contentImage, departmentName, registeredAt, noticeName
    }
}
