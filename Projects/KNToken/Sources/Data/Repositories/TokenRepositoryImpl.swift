//
//  TokenRepositoryImpl.swift
//  KNToken
//
//  Created by 이정훈 on 1/27/26.
//

import Factory
import Foundation
import KNNetwork
import KNUtility

actor TokenRepositoryImpl: TokenRepository {
    @Injected(\.remoteDataSource) private var dataSource
    private let baseURL: String? = Bundle.module.tokenURL
    
    /// Registers a new FCM token to the KNUTICE server.
    ///
    /// This method sends a POST request to the server. Note that the actual FCM token
    /// should be handled by the interceptor or the data source layer since `isInterceptable`
    /// is set to `true`.
    ///
    /// - Parameter token: The FCM token to register.
    /// - Throws:
    ///   - `NetworkError.invalidURL` if the base URL is missing.
    ///   - `Task.checkCancellation` errors if the request is aborted.
    func register(token: String) async throws {
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
            isInterceptable: true    // 새로 발급 받은 FCM 토큰은 요청 header에 저장
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
    func update(oldFCMToken: String?, newFCMToken: String) async throws {
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
