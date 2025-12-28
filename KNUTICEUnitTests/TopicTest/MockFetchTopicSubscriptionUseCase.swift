//
//  MockTopicSubscriptionRepository.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/10/25.
//

import KNUTICECore
@testable import KNUTICE

actor MockFetchTopicSubscriptionUseCase: FetchTopicSubscriptionsUseCase {

    func execute(for topicType: TopicType) async throws -> [TopicSubscriptionKey] {
        return [
            .notice(.academicNotice),
            .notice(.eventNotice)
        ]
    }

}
