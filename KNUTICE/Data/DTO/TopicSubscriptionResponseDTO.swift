//
//  TopicSubscriptionResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/17/25.
//

import Foundation
import KNUTICECore

// MARK: - TopicSubscribtionResponseDTO
struct TopicSubscriptionResponseDTO: Decodable {
    let metaData: MetaData
    let data: TopicSubscriptionData
}

// MARK: - TopicSubscriptionData
struct TopicSubscriptionData: Decodable {
    let subscribedTopics: [String]
}
