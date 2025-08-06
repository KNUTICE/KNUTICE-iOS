//
//  TokenInterceptor.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Alamofire
import Factory
import FirebaseMessaging
import Foundation

public struct TokenInterceptor: RequestInterceptor, @unchecked Sendable {
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        Task {
            var urlRequest = urlRequest
            let token = try? await getFCMToken()
            
            guard let token else {
                completion(.failure(TokenError.notFound))
                return
            }
            
            urlRequest.headers.add(name: "fcmToken", value: token)
            completion(.success(urlRequest))
        }
    }
    
    private func getFCMToken() async throws -> String {
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
