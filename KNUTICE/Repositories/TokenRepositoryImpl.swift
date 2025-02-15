//
//  TokenRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import RxSwift
import Combine
import Foundation
import FirebaseMessaging
import Factory

final class TokenRepositoryImpl: TokenRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func registerToken(token: String) -> Observable<Bool> {
        let remoteURL = Bundle.main.tokenURL
        let params = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "fcmToken": token
            ]
        ] as [String : Any]
        
        return dataSource.sendPostRequest(to: remoteURL, params: params, resultType: TokenSaveResponseDTO.self)
            .map {
                return $0.result.resultCode == 200 ? true : false
            }
            .asObservable()
    }
    
    func getFCMToken() -> AnyPublisher<String, any Error> {
        return Future { promise in
            Messaging.messaging().token { token, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(token ?? ""))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
