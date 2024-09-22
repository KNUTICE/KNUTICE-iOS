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

final class TokenRepositoryImpl: TokenRepository {
    private let dataSource: TokenDataSource
    
    init(dataSource: TokenDataSource) {
        self.dataSource = dataSource
    }
    
    func registerToken(token: String) -> Observable<Bool> {
        let remoteURL = Bundle.main.tokenURL
        let params = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "deviceToken": token
            ]
        ] as [String : Any]
        
        return dataSource.sendPostRequest(to: remoteURL, params: params)
            .map {
                if let statusCode = try? $0.get().result.resultCode, statusCode == 200 {
                    return true
                }
                
                return false
            }
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
