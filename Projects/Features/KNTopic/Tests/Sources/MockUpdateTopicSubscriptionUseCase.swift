//
//  MockUpdateTopicSubscriptionUseCase.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/11/25.
//

import KNUtility
@testable import KNTopic

actor MockUpdateTopicSubscriptionUseCase: UpdateTopicSubscriptionUseCase {
    func execute(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws {}
    
}
