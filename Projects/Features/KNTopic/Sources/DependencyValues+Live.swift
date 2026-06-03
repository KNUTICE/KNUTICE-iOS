//
//  DependencyValues+Live.swift
//  KNTopic
//
//  Created by 이정훈 on 1/27/26.
//

import ComposableArchitecture
import KNDomain

extension DependencyValues {
    public var fetchTopicSubscriptionUseCase: FetchTopicSubscriptionsUseCase {
        get { self[FetchTopicSubscriptionUseCaseKey.self] }
        set { self[FetchTopicSubscriptionUseCaseKey.self] = newValue }
    }
    
    public var updateTopicSubscriptionUseCase: UpdateTopicSubscriptionUseCase {
        get { self[UpdateTopicSubscriptionUseCaseKey.self] }
        set { self[UpdateTopicSubscriptionUseCaseKey.self] = newValue }
    }
}

fileprivate enum FetchTopicSubscriptionUseCaseKey: DependencyKey {
    static var liveValue: FetchTopicSubscriptionsUseCase {
        fatalError("Must override from App")
    }
}

fileprivate enum UpdateTopicSubscriptionUseCaseKey: DependencyKey {
    static var liveValue: UpdateTopicSubscriptionUseCase {
        fatalError("Must override from App")
    }
}
