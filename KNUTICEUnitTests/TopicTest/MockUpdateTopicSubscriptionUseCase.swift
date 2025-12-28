//
//  MockUpdateTopicSubscriptionUseCase.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/11/25.
//

import KNUTICECore
@testable import KNUTICE

actor MockUpdateTopicSubscriptionUseCase: UpdateTopicSubscriptionUseCase {
    func execute(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws {}
    
}
