//
//  TopicSubscriptionService.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Factory
import Foundation
import KNUTICECore

protocol TopicSubscriptionService: Actor {
    func update(_ noticeName: NoticeCategory, to value: Bool) async -> Result<Void, Error>
}

actor TopicSubscriptionServiceImpl: TopicSubscriptionService {
    @Injected(\.tokenRepository) private var tokenRepository
    @Injected(\.topicSubscriptionRepository) private var topicSubscriptionRepository
    
    func update(_ noticeName: NoticeCategory, to value: Bool) async -> Result<Void, any Error> {
        guard !Task.isCancelled else {
            return .failure(CancellationError())
        }
        
        do {
            let token = try? await tokenRepository.getFCMToken()
            
            guard let token else {
                return .failure(TokenError.notFound)
            }
            
            let params = createParams(token: token, noticeName: noticeName.rawValue, isSubscribed: value)
            try await topicSubscriptionRepository.update(params: params)
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    private func createParams(token: String, noticeName: String, isSubscribed: Bool) -> [String: any Sendable] {
        let params = [
            "result": commonResultInfo,
              "body": [
                  "fcmToken": token,
                  "noticeName" : noticeName,
                  "isSubscribed" : isSubscribed
              ]
        ]
        
        return params
    }
}
