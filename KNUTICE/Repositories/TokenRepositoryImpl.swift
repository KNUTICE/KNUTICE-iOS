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
import KNUTICECore

final class TokenRepositoryImpl: TokenRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func registerToken(token: String) -> Observable<Bool> {
        do {
            let (endpoint, params) = try makeRegisterTokenRequest(token: token)
            
            return dataSource.request(
                endpoint,
                method: .post,
                parameters: params,
                decoding: PostResponseDTO.self
            )
            .map { $0.result.resultCode == 200 }
            .asObservable()
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func register(token: String) async throws -> Bool {
        let (endpoint, params) = try makeRegisterTokenRequest(token: token)
        
        let dto = try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
        
        return dto.result.resultCode == 200
    }
    
    func getFCMToken() -> AnyPublisher<String, any Error> {
        return Future { promise in
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                //Firebase 10.4.0 SDK를 사용하는 UnitTest에서 iOS 16 Simulator와 Xcode 13, Apple Silicon HW를 만족하지 않으면 토큰을 사용할 수 없는 이슈
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
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            //Firebase 10.4.0 SDK를 사용하는 UnitTest에서 iOS 16 Simulator와 Xcode 13, Apple Silicon HW를 만족하지 않으면 토큰을 사용할 수 없는 이슈
            //UnitTest 환경에서 임의의 토큰 정보 반환
            return ""
        }
        
        try Task.checkCancellation()
        
        return try await Messaging.messaging().token()
    }
    
    private func makeRegisterTokenRequest(token: String) throws -> (endpoint: String, params: [String: Any]) {
        guard let endpoint = Bundle.main.tokenURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        let params: [String: Any] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "fcmToken": token,
                "deviceType": "iOS"
            ]
        ]
        
        return (endpoint, params)
    }
}
