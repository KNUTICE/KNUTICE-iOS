//
//  Container+Instance.swift
//  KNTopic
//
//  Created by 이정훈 on 1/27/26.
//

import Factory

public extension Container {
    var topicSubscriptionRepository: Factory<TopicSubscriptionRepository> {
        Factory(self) {
            TopicSubscriptionRepositoryImpl()
        }
    }
}
