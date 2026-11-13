//
//  FetchTopicSubscriptionsUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/11/25.
//

import Foundation

public final class FetchTopicSubscriptionsUseCase: Sendable {
    private let topicSubscriptionRepository: TopicSubscriptionRepository
    private let topicRepository: TopicRepository
    
    public init(
        topicSubscriptionRepository: TopicSubscriptionRepository,
        topicRepository: TopicRepository
    ) {
        self.topicSubscriptionRepository = topicSubscriptionRepository
        self.topicRepository = topicRepository
    }
    
    public func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey] {
        let ids = try await topicSubscriptionRepository.fetch(for: topicType)
        var keys = [TopicSubscriptionKey]()
        
        try await withThrowingTaskGroup(of: [any CategoryProtocol].self) { group in
            for id in ids {
                group.addTask {
                    try await self.topicRepository.getTopics(id: id)
                }
            }
            
            for try await topics in group {
                for topic in topics {
                    if let category = topic as? NoticeCategory {
                        keys.append(.notice(category))
                    } else if let category = topic as? MajorCategory {
                        keys.append(.major(category))
                    } else if let category = topic as? CafeteriaCategory {
                        switch category {
                        case .staffCafeteria:
                            keys.append(.staffCafeteria)
                        case .studentCafeteria:
                            keys.append(.studentCafeteria)
                        }
                    }
                }
            }
            
        }
        
        return keys
    }
    
}
