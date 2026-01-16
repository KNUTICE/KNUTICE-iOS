//
//  UpdateFCMTokenUseCase.swift
//  KNToken
//
//  Created by 이정훈 on 1/16/26.
//

import Factory
import Foundation
import KNNetwork
import KNUtility

public protocol UpdateFCMTokenUseCase {
    func execute() async throws
}

public actor UpdateFCMTokenUseCaseImpl: UpdateFCMTokenUseCase {
    @Injected(\.remoteDataSource) private var dataSource
    private let baseURL: String? = Bundle.module.tokenURL
    
    public func execute() async throws {
        guard let endpoint = baseURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        try Task.checkCancellation()
        
        async let existingToken = FCMTokenKeychainManager.shared.read()
        async let newToken = FCMTokenManager.shared.getToken()
        
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
}
