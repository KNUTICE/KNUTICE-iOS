//
//  TokenRepositoryImpl.swift
//  KNToken
//
//  Created by 이정훈 on 1/27/26.
//

import Factory
import Foundation
import KNDomain
import KNNetwork
import KNUtility

public actor TokenRepositoryImpl: TokenRepository {
    @Injected(\.remoteDataSource) private var dataSource
    private let baseURL: String? = Bundle.module.tokenURL
    
    public init() {}
    
    /// Registers a newly issued FCM token with the KNUTICE server.
    ///
    /// This method sends a `POST` request with the device type in the request
    /// body. The FCM token itself is not passed as a parameter — it is
    /// retrieved automatically and injected into the request header by
    /// `NetworkInterceptor` when `useFCMToken` is set to `true`.
    ///
    /// Cancellation is checked before the network call is made, so if the
    /// enclosing `Task` has already been cancelled the method exits immediately
    /// without sending a request.
    ///
    /// - Throws:
    ///   - `CancellationError` if the enclosing `Task` was cancelled before
    ///     the request could be dispatched.
    ///   - `NetworkError.invalidURL` if `tokenURL` is absent or malformed
    ///     in the module bundle.
    ///   - Any networking or decoding error propagated from `RemoteDataSource`.
    public func register() async throws {
        try Task.checkCancellation()
        
        // KNUTICE 서버에 토큰 업로드
        guard let endpoint = baseURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        let params = ["deviceType": "iOS"] as [String: any Sendable]
        try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self,
            useFCMToken: true    // 새로 발급 받은 FCM 토큰은 요청 header에 저장
        )
    }
    
    /// Updates an existing FCM token on the KNUTICE server.
    ///
    /// This method uses a PATCH request to replace an old token with a new one.
    /// - The **old** token is passed in the request **body**.
    /// - The **new** token is passed in the request **header**.
    ///
    /// - Parameters:
    ///   - oldFCMToken: The previous token stored in the Keychain (nullable).
    ///   - newFCMToken: The freshly generated FCM token from the device.
    /// - Throws: `NetworkError` if the request fails or URL is invalid.
    public func update(oldFCMToken: String?, newFCMToken: String) async throws {
        try Task.checkCancellation()
        
        guard let endpoint = baseURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        let params = [
            "oldFcmToken": oldFCMToken,    // 기존 FCM 토큰은 요청 바디에 저장
            "deviceType": "iOS"
        ] as [String : any Sendable]
        
        try await dataSource.request(
            endpoint,
            method: .patch,
            parameters: params,
            headers: ["fcmToken": newFCMToken],    // 새로운 FCM 토큰은 요청 헤더에 저장
            decoding: PostResponseDTO.self
        )
    }
    
    
}
