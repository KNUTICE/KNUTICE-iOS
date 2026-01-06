//
//  TopicSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import KNUtility

protocol TopicSubscriptionRepository: Actor {
    func fetch(for topicType: TopicType) async throws -> [TopicSubscriptionKey]
    func update(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws
}
