//
//  TokenInterceptor.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Alamofire
import Foundation

public struct TokenInterceptor: RequestInterceptor, @unchecked Sendable {
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @Sendable @escaping (Result<URLRequest, any Error>) -> Void) {
        Task {
            var urlRequest = urlRequest
            
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
