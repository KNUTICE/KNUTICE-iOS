//
//  TopicResponseDTO.swift
//  KNData
//
//  Created by 이정훈 on 7/7/26.
//

import Foundation

struct TopicResponseDTO: Decodable {
    let metaData: MetaData
    let data: [TopicData]?
}

struct TopicData: Decodable {
    let topic: String
    let topicId: Int
    let name: String
    let college: String
}
