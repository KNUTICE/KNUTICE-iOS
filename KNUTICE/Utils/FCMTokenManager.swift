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
    @Injected(\.remoteDataSource) private var dataSource
    
    static let shared: FCMTokenManager = .init()
    
    private init() {}
    
    func uploadToken() async throws {
        let fcmToken = try await getToken()
        
        guard let baseURL = Bundle.main.tokenURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Token_URL' in resource.")
        }
        
        try Task.checkCancellation()
        
        let params = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "fcmToken": fcmToken
            ]
        ] as [String : Any]
        
        try await dataSource.request(
            baseURL + "/silent-push",
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
    }
    
    func getToken() async throws -> String {
        try Task.checkCancellation()
        
        return try await Messaging.messaging().token()
    }
}
