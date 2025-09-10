//
//  FCMTokenService.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/14/25.
//

import Factory
import Foundation
import KNUTICECore

protocol FCMTokenService: Actor {
    func register(fcmToken: String) async throws
}

actor FCMTokenServiceImpl: FCMTokenService {
    func register(fcmToken: String) async throws {
        try Task.checkCancellation()
        
        // KNUTICE 서버에 토큰 업로드
        try await FCMTokenManager.shared.register()
        
        // KNUTICE 서버에 저장된 토큰을 Keychain에 저장
        await FCMTokenKeychainManager.shared.save(fcmToken: fcmToken)
    }
}
