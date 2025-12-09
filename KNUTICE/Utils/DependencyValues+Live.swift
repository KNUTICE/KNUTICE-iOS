//
//  DependencyValues+Live.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/9/25.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
    var topicSubscriptionRepository: TopicSubscriptionRepository {
        get { self[TopicSubscriptionRepositoryKey.self] }
        set { self[TopicSubscriptionRepositoryKey.self] = newValue }
    }
}

private enum TopicSubscriptionRepositoryKey: DependencyKey {
    static let liveValue: TopicSubscriptionRepository = TopicSubscriptionRepositoryImpl()
}
