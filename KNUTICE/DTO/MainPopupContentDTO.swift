//
//  MainPopupContentDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Foundation
import KNUTICECore

// MARK: - MainPopupContentDTO
struct MainPopupContentDTO: Decodable {
    let result: RequestResult
    let body: MainPopupContentBody?
}

// MARK: - MainPopupContentBody
struct MainPopupContentBody: Decodable {
    let title, content, contentURL, registeredAt: String

    enum CodingKeys: String, CodingKey {
        case title, content
        case contentURL = "contentUrl"
        case registeredAt
    }
}
