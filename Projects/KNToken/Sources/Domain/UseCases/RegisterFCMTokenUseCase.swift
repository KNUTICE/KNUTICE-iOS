//
//  RegisterFCMTokenUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/31/25.
//

import Factory
import Foundation
import KNNetwork
import KNUtility

public protocol RegisterFCMTokenUseCase: Actor {
    /// Registers the provided FCM token with the KNUTICE server
    /// and stores the token in the Keychain.
    ///
    /// - Parameter token: The FCM token to be registered.
    /// - Throws: An error if the registration request fails or the task is cancelled.
    func execute(token: String) async throws
}

public actor RegisterFCMTokenUseCaseImpl: RegisterFCMTokenUseCase {
    @Injected(\.remoteDataSource) private var dataSource
    
    public func execute(token: String) async throws {
        try Task.checkCancellation()
        
        // KNUTICE 서버에 토큰 업로드
        guard let endpoint = Bundle.module.tokenURL else {
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
        
        // KNUTICE 서버에 저장된 토큰을 Keychain에 저장
        await FCMTokenKeychainManager.shared.save(fcmToken: token)
    }
}
