//
//  NotificationSubscriptionService.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Combine
import Factory
import Foundation

protocol NotificationSubscriptionService {
    func updatePermission(_ notice: NoticeCategory, to value: Bool) -> AnyPublisher<Void, any Error>
}

final class NotificationSubscriptionServiceImpl: NotificationSubscriptionService {
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepository
    @Injected(\.notificationRepository) private var repository: NotificationSubscriptionRepository
    
    func updatePermission(_ notice: NoticeCategory, to value: Bool) -> AnyPublisher<Void, any Error> {
        return tokenRepository.getFCMToken()
            .flatMap { [weak self] token -> AnyPublisher<Bool, any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                let params: [String: Any] = self.createParams(token: token, noticeName: notice.rawValue, isSubscribed: value)
                return self.repository.updateToServer(params: params)
            }
            .flatMap { [weak self] result -> AnyPublisher<Void, any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                return self.repository.updateToLocal(key: notice, value: value)
            }
            .eraseToAnyPublisher()
    }
    
    private func createParams(token: String, noticeName: String, isSubscribed: Bool) -> [String: Any] {
        let params = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
              ],
              "body": [
                  "fcmToken": token,
                  "noticeName" : noticeName,
                  "isSubscribed" : isSubscribed
              ]
        ]
        
        return params
    }
}
