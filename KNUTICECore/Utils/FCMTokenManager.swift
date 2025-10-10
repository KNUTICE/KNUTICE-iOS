//
//  FCMTokenManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/12/25.
//

import Combine
import Factory
import FirebaseMessaging
import Foundation

public actor FCMTokenManager {
    //MARK: - Properies
    
    @Injected(\.remoteDataSource) private var dataSource
    
    public static let shared: FCMTokenManager = .init()
    
    private init() {}
    
    //MARK: - Methods
    
    public func updateToken() async throws {
        guard let endpoint = Bundle.main.tokenURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        try Task.checkCancellation()
        
        async let existingToken = FCMTokenKeychainManager.shared.read()
        async let newToken = getToken()
        
        let params = [
            "oldFcmToken": await existingToken,    // 기존 FCM 토큰은 요청 바디에 저장
            "deviceType": "iOS"
        ] as [String : any Sendable]
        
        try await dataSource.request(
            endpoint,
            method: .patch,
            parameters: params,
            headers: ["fcmToken": try await newToken],    // 새로운 FCM 토큰은 요청 헤더에 저장
            decoding: PostResponseDTO.self
        )
        
        // 요청 성공 후 키체인에 새 토큰 저장
        await FCMTokenKeychainManager.shared.save(fcmToken: try await newToken)
    }
    
    public func register() async throws {
        guard let endpoint = Bundle.standard.tokenURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        let params = ["deviceType": "iOS"] as [String: any Sendable]
        
        try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self,
            isInterceptable: true    // 새로 발급 받은 FCM 토큰은 요청 header에 저장
        )
    }
    
    public func getToken() async throws -> String {
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            // Firebase 10.4.0 SDK를 사용하는 UnitTest에서 iOS 16 Simulator와 Xcode 13, Apple Silicon HW를 만족하지 않으면 토큰을 사용할 수 없는 이슈
            // UnitTest 환경에서 임의의 토큰 정보 반환
            return ""
        }
        
        try Task.checkCancellation()
        
        return try await Messaging.messaging().token()
    }
    
    public nonisolated func getToken() -> AnyPublisher<String, any Error> {
        return Future { promise in
            nonisolated(unsafe) let promise = promise
            
            guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
                // Firebase 10.4.0 SDK를 사용하는 UnitTest에서 iOS 16 Simulator와 Xcode 13, Apple Silicon HW를 만족하지 않으면 토큰을 사용할 수 없는 이슈
                // UnitTest 환경에서 임의의 토큰 정보 반환
                promise(.success(""))
                return
            }
            
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
