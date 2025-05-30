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
        
        return dataSource.sendPostRequest(to: remoteURL, params: params, resultType: PostResponseDTO.self)
            .map {
                return $0.result.resultCode == 200 ? true : false
            }
            .asObservable()
    }
    
    func getFCMToken() -> AnyPublisher<String, any Error> {
        return Future { promise in
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                //Firebase 10.4.0 SDK를 사용하는 UnitTest에서 iOS 16 Simulator와 Xcode 13,  Apple Silicon HW를 만족하지 않으면 토큰을 사용할 수 없는 이슈
                //UnitTest 환경에서 임의의 토큰 정보 반환
                promise(.success(""))
            } else {
                Messaging.messaging().token { token, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(token ?? ""))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getFCMToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                //Firebase 10.4.0 SDK를 사용하는 UnitTest에서 iOS 16 Simulator와 Xcode 13,  Apple Silicon HW를 만족하지 않으면 토큰을 사용할 수 없는 이슈
                //UnitTest 환경에서 임의의 토큰 정보 반환
                continuation.resume(returning: "")
            } else {
                Messaging.messaging().token { token, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: token ?? "")
                    }
                }
            }
        }
    }
}
