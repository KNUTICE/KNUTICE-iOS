//
//  NoticeSummaryDTO.swift
//  KNNoticeSummary
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation
import KNUtility

// MARK: - NoticeSummaryDTO
struct NoticeSummaryDTO: Decodable {
    let metaData: MetaData
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let nttID: Int
    let contentSummary: String

    enum CodingKeys: String, CodingKey {
        case nttID = "nttId"
        case contentSummary
    }
}
