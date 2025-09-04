//
//  TokenInterceptor.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/30/25.
//

import Alamofire
import Foundation

public struct TokenInterceptor: RequestInterceptor, @unchecked Sendable {
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        Task {
            var urlRequest = urlRequest
            let token = try? await FCMTokenManager.shared.getToken()
            
            guard let token else {
                completion(.failure(TokenError.notFound))
                return
            }
            
            urlRequest.headers.add(name: "fcmToken", value: token)
            completion(.success(urlRequest))
        }
    }
}
