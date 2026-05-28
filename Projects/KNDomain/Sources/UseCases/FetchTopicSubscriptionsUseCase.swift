//
//  FetchTopicSubscriptionsUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/11/25.
//

import Foundation

public protocol FetchTopicSubscriptionsUseCase: Sendable {
    func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey]
}

public final class FetchTopicSubscriptionsUseCaseImpl: FetchTopicSubscriptionsUseCase {
    private let repository: TopicSubscriptionRepository
    
    public init(repository: TopicSubscriptionRepository) {
        self.repository = repository
    }
    
    public func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey] {
        return try await repository.fetch(for: topicType)
    }
    
}
