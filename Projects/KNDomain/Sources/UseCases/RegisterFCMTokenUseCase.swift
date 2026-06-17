//
//  RegisterFCMTokenUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/31/25.
//

import Factory
import KNUtility

public final class RegisterFCMTokenUseCase: Sendable {
    private let repository: TokenRepository
    
    public init(repository: TokenRepository) {
        self.repository = repository
    }
    
    /// Executes the token registration workflow.
    ///
    /// The workflow consists of the following steps:
    /// 1. Verifies if the current task has been cancelled.
    /// 2. Sends the token to the KNUTICE server via the repository.
    /// 3. Upon successful server registration, saves the token to the secure Keychain.
    ///
    /// - Parameter token: The FCM token to be registered.
    /// - Throws: Any error encountered during the repository registration process.
    public func execute(token: String) async throws {
        try Task.checkCancellation()
        
        // KNUTICE 서버에 저장된 토큰을 Keychain에 저장
        await FCMTokenKeychainManager.shared.save(fcmToken: token)
        
        // KNUTICE 서버에 토큰 업로드
        try await repository.register()
    }
}
