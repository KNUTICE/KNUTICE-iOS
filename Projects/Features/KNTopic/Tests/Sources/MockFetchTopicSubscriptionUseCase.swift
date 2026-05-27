//
//  MockTopicSubscriptionRepository.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/10/25.
//

@testable import KNTopic

actor MockFetchTopicSubscriptionUseCase: FetchTopicSubscriptionsUseCase {

    func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey] {
        if case .notice = topicType {
            return [
                .notice(.academicNotice),
                .notice(.eventNotice)
            ]
        } else if case .meal = topicType {
            return [
                .staffCafeteria,
                .studentCafeteria
            ]
        } else {
            return []
        }
    }

}
