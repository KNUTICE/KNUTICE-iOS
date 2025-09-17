//
//  TopicSubscriptionResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/17/25.
//

import Foundation

// MARK: - TopicSubscribtionResponseDTO
struct TopicSubscriptionResponseDTO: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: TopicSubscriptionData
}

// MARK: - TopicSubscriptionData
struct TopicSubscriptionData: Codable {
    let subscribedTopics: [String]
}
