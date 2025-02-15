//
//  NotificationSubscriptionService.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Combine
import Factory

protocol NotificationSubscriptionService {
    func updatePermission(_ notice: NoticeCategory, to value: Bool) -> AnyPublisher<Void, any Error>
}

final class NotificationSubscriptionServiceImpl: NotificationSubscriptionService {
    enum RemoteServerError: Error {
        case invalidResponse
    }
    
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepository
    @Injected(\.notificationRepository) private var repository: NotificationSubscriptionRepository
    
    func updatePermission(_ notice: NoticeCategory, to value: Bool) -> AnyPublisher<Void, any Error> {
        return tokenRepository.getFCMToken()
            .flatMap { token -> AnyPublisher<Bool, any Error> in
                let params: [String: Any] = self.makeParams(token: token, noticeName: notice.rawValue, isSubscribed: value)
                return self.repository.updateToServer(params: params)
            }
            .flatMap { result -> AnyPublisher<Void, any Error> in
                guard result else {
                    return Fail(error: RemoteServerError.invalidResponse).eraseToAnyPublisher()
                }
                
                return self.repository.updateToLocal(key: notice, value: value)
            }
            .eraseToAnyPublisher()
    }
    
    private func makeParams(token: String, noticeName: String, isSubscribed: Bool) -> [String: Any] {
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
