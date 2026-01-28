//
//  DependencyValues+Live.swift
//  KNTopic
//
//  Created by 이정훈 on 1/27/26.
//

import ComposableArchitecture

extension DependencyValues {
    var fetchTopicSubscriptionUseCase: FetchTopicSubscriptionsUseCase {
        get { self[FetchTopicSubscriptionUseCaseKey.self] }
        set { self[FetchTopicSubscriptionUseCaseKey.self] = newValue }
    }
    
    var updateTopicSubscriptionUseCase: UpdateTopicSubscriptionUseCase {
        get { self[UpdateTopicSubscriptionUseCaseKey.self] }
        set { self[UpdateTopicSubscriptionUseCaseKey.self] = newValue }
    }
}

fileprivate enum FetchTopicSubscriptionUseCaseKey: DependencyKey {
    static let liveValue: FetchTopicSubscriptionsUseCase = FetchTopicSubscriptionsUseCaseImpl()
}

fileprivate enum UpdateTopicSubscriptionUseCaseKey: DependencyKey {
    static let liveValue: UpdateTopicSubscriptionUseCase = UpdateTopicSubscriptionUseCaseImpl()
}
