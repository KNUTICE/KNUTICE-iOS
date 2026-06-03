//
//  UpdateTopicSubscriptionUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/11/25.
//

import KNUtility

public protocol UpdateTopicSubscriptionUseCase: Sendable {
    func execute(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws
}

public final class UpdateTopicSubscriptionUseCaseImpl: UpdateTopicSubscriptionUseCase {
    private let repository: TopicSubscriptionRepository
    
    public init(repository: TopicSubscriptionRepository) {
        self.repository = repository
    }
    
    public func execute(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws {
        try await repository.update(of: type, topic: topic, isEnabled: isEnabled)
    }
    
}
