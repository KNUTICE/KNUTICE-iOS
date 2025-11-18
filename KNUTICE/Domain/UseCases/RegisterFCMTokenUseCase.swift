//
//  RegisterFCMTokenUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/31/25.
//

import Foundation
import KNUTICECore

protocol RegisterFCMTokenUseCase: Actor {
    /// Registers the provided FCM token with the KNUTICE server
    /// and stores the token in the Keychain.
    ///
    /// - Parameter token: The FCM token to be registered.
    /// - Throws: An error if the registration request fails or the task is cancelled.
    func execute(token: String) async throws
}

actor RegisterFCMTokenUseCaseImpl: RegisterFCMTokenUseCase {
    func execute(token: String) async throws {
        try Task.checkCancellation()
        
        // KNUTICE 서버에 토큰 업로드
        try await FCMTokenManager.shared.register()
        
        // KNUTICE 서버에 저장된 토큰을 Keychain에 저장
        await FCMTokenKeychainManager.shared.save(fcmToken: token)
    }
}
