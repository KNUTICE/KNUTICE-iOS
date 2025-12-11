//
//  MockTopicSubscriptionRepository.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/10/25.
//

import KNUTICECore
@testable import KNUTICE

actor MockTopicSubscriptionRepository: TopicSubscriptionRepository {

    func fetch(for topicType: TopicType) async throws -> [TopicSubscriptionKey] {
        return [
            .notice(.academicNotice),
            .notice(.eventNotice)
        ]
    }

    func update<T>(
        of type: TopicType,
        topic: T,
        isEnabled: Bool
    ) async throws where T : RawRepresentable, T.RawValue == String {
        // 테스트에서는 아무 동작도 안 함
    }
}
