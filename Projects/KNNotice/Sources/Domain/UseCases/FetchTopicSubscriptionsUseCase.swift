//
//  FetchTopicSubscriptionsUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/11/25.
//

import Factory

public protocol FetchTopicSubscriptionsUseCase: Actor {
    func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey]
}

public actor FetchTopicSubscriptionsUseCaseImpl: FetchTopicSubscriptionsUseCase {
    @Injected(\.topicSubscriptionRepository) private var repository
    
    public init() {}
    
    public func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey] {
        return try await repository.fetch(for: topicType)
    }
    
    
}
