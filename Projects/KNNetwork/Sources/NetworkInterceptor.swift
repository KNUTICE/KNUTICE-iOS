//
//  TokenInterceptor.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Alamofire
import Foundation
import KNUtility

struct NetworkInterceptor: RequestInterceptor, @unchecked Sendable {
    
    /// HTTP header field name constants used for request modification.
    private struct HttpHeaderField {
        /// The User-Agent header field name.
        static let userAgent = "User-Agent"
        /// The FCM token header field name.
        static let fcmToken = "fcmToken"
    }
    
    /// Determines whether the FCM token should be injected into outgoing requests.
    private let shouldContainFCMToken: Bool
    
    init(shouldContainFCMToken: Bool) {
        self.shouldContainFCMToken = shouldContainFCMToken
    }
    
    /// Adapts the outgoing `URLRequest` before it is sent.
    ///
    /// This method always appends a static `User-Agent: ios` header.
    /// When `shouldContainFCMToken` is `true`, it additionally fetches the
    /// current FCM registration token asynchronously and attaches it as the
    /// `fcmToken` header before forwarding the request.
    ///
    /// - Parameters:
    ///   - urlRequest: The original request to be adapted.
    ///   - session:    The `Session` that will send the request.
    ///   - completion: A closure that must be called with either the modified
    ///                 request (`.success`) or an error (`.failure`).
    ///                 Call `.failure(TokenError.notFound)` when the FCM token
    ///                 cannot be retrieved.
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @Sendable @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var urlRequest = urlRequest
        
        // User-Agent 헤더 추가
        urlRequest.headers.add(name: "User-Agent", value: "ios")
        
        guard shouldContainFCMToken else {
            completion(.success(urlRequest))
            return
        }
        
        // fcmToken 헤더 추가
        Task {
            do {
                let token = try await FCMTokenManager.shared.getToken()
                urlRequest.headers.add(name: "fcmToken", value: token)
                completion(.success(urlRequest))
            } catch {
                completion(.failure(TokenError.notFound))
            }
        }
    }
    
}
