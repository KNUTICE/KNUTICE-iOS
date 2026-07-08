//
//  UpdateTopicSubscriptionUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/11/25.
//

import KNUtility

public final class UpdateTopicSubscriptionUseCase: Sendable {
    private let repository: TopicSubscriptionRepository
    
    public init(repository: TopicSubscriptionRepository) {
        self.repository = repository
    }
    
    public func execute(of type: TopicType, topicID id: Int, isEnabled: Bool) async throws {
        try Task.checkCancellation()
        
        if isEnabled {
            try await repository.subscribe(of: type, topicID: id)
        } else {
            try await repository.unsubscribe(of: type, topicID: id)
        }
    }
    
}
