//
//  FCMTokenManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/12/25.
//

import Factory
import FirebaseMessaging
import Foundation

struct FCMTokenManager {
    //MARK: - Properies
    
    @Injected(\.remoteDataSource) private var dataSource
    
    static let shared: FCMTokenManager = .init()
    
    private init() {}
    
    //MARK: - Methods
    
    func uploadToken() async throws {
        guard let baseURL = Bundle.main.tokenURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        async let fcmToken = getToken()
        async let oldToken = FCMTokenKeychainManager.shared.read()
        
        let (newToken, existingToken) = try await (fcmToken, oldToken)
        
        try Task.checkCancellation()
        
        let params = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "oldFcmToken": existingToken,
                "newFcmToken": newToken,
                "deviceType": "iOS"
            ]
        ] as [String : Any]
        
        try await dataSource.request(
            baseURL,
            method: .patch,
            parameters: params,
            decoding: PostResponseDTO.self
        )
        
        await FCMTokenKeychainManager.shared.save(fcmToken: newToken)
    }
    
    func getToken() async throws -> String {
        try Task.checkCancellation()
        
        return try await Messaging.messaging().token()
    }
}
