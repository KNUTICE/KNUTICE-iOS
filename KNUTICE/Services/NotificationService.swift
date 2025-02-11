//
//  NotificationService.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Combine
import Factory

protocol NotificationService {
    func updatePermission(_ notice: NotificationKind, to value: Bool) -> AnyPublisher<Void, any Error>
}

final class NotificationServiceImpl: NotificationService {
    enum RemoteServerError: Error {
        case invalidResponse
    }
    
    @Injected(\.tokenRepository) private var tokenRepository: TokenRepository
    @Injected(\.localNotificationRepository) private var localRepository: LocalNotificationRepository
    @Injected(\.remoteNotificationRepository) private var remoteRepository: RemoteNotificationRepository
    
    func updatePermission(_ notice: NotificationKind, to value: Bool) -> AnyPublisher<Void, any Error> {
        return tokenRepository.getFCMToken()
            .flatMap { token -> AnyPublisher<Bool, any Error> in
                let params: [String: Any] = self.makeParams(token: token, noticeName: notice.rawValue, isSubscribed: value)
                return self.remoteRepository.update(params: params)
            }
            .flatMap { result -> AnyPublisher<Void, any Error> in
                guard result else {
                    return Fail(error: RemoteServerError.invalidResponse).eraseToAnyPublisher()
                }
                
                return self.localRepository.update(key: notice, value: value)
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
