//
//  TopicSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import KNUTICECore

protocol TopicSubscriptionRepository: Actor {
    func fetch(for topicType: TopicType) async throws -> [TopicSubscriptionKey]
    func update<T>(of type: TopicType, topic: T, isEnabled: Bool) async throws where T: RawRepresentable, T.RawValue == String
}
