//
//  FCMTokenService.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/14/25.
//

import Factory
import Foundation

protocol FCMTokenService {
    @discardableResult
    func register(fcmToken: String) async throws -> Bool
}

final class FCMTokenServiceImpl: FCMTokenService {
    @Injected(\.tokenRepository) private var repository
    
    @discardableResult
    func register(fcmToken: String) async throws -> Bool {
        try await repository.register(token: fcmToken)
        
        if Task.isCancelled {
            return false
        }
        
        return await FCMTokenKeychainManager.shared.save(fcmToken: fcmToken)
//        return await FCMTokenKeychainManager.shared.save(fcmToken: "testtest")
    }
}
