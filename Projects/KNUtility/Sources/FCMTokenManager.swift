//
//  FCMTokenManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/12/25.
//

import Combine
import FirebaseMessaging
import Foundation

public actor FCMTokenManager {
    //MARK: - Properies
    
    public static let shared: FCMTokenManager = .init()
    
    // MARK: - Initializer
    
    private init() {}
    
    //MARK: - Methods
    
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
