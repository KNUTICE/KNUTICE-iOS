//
//  NotificationPermissionService.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Combine

protocol NotificationPermissionService {
    func updatePermission(_ notice: NotificationKind, to value: Bool) -> AnyPublisher<Void, any Error>
}

final class NotificationPermissionServiceImpl<
    T: TokenRepository,
    L: LocalNotificationPermissionRepository,
    R: RemoteNotificationPermissionRepository
>: NotificationPermissionService {
    enum RemoteServerError: Error {
        case invalidResponse
    }
    
    private let tokenRepository: T
    private let localRepository: L
    private let remoteRepository: R
    
    init(tokenRepository: T,
         localRepository: L,
         remoteRepository: R) {
        self.tokenRepository = tokenRepository
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
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
                  "deviceToken": token,
                  "noticeName" : noticeName,
                  "isSubscribed" : isSubscribed
              ]
        ]
        
        return params
    }
}
