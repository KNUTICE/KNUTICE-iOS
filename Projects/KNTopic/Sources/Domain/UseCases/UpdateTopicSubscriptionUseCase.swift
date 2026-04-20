//
//  UpdateTopicSubscriptionUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/11/25.
//

import Factory
import KNUtility

public protocol UpdateTopicSubscriptionUseCase: Actor {
    func execute(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws
}

public actor UpdateTopicSubscriptionUseCaseImpl: UpdateTopicSubscriptionUseCase {
    @Injected(\.topicSubscriptionRepository) private var repository
    
    public func execute(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws {
        try await repository.update(of: type, topic: topic, isEnabled: isEnabled)
    }
    
}
