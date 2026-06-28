//
//  UpdateFCMTokenUseCase.swift
//  KNToken
//
//  Created by 이정훈 on 1/16/26.
//

import Factory
import KNUtility

public final class UpdateFCMTokenUseCase: Sendable {
    private let repository: TokenRepository
    
    public init(repository: TokenRepository) {
        self.repository = repository
    }
    
    /// Updates the FCM token on the KNUTICE server and refreshes the local Keychain.
    ///
    /// The execution flow is as follows:
    /// 1. Validates task cancellation state.
    /// 2. Fetches the existing token from Keychain and the new token from FCMManager in parallel.
    /// 3. Sends an update request to the server with both tokens.
    /// 4. Persists the new token in the Keychain upon a successful server response.
    ///
    /// - Throws:
    ///   - `CancellationError` if the task is cancelled.
    ///   - Server-side errors or local storage access errors.
    public func execute() async throws {
        try Task.checkCancellation()
        
        async let existingToken = FCMTokenKeychainManager.shared.read()
        async let newToken = FCMTokenManager.shared.getToken()
        
        // 요청 성공 후 키체인에 새 토큰 저장
        try await FCMTokenKeychainManager.shared.save(fcmToken: newToken)
        
        try await repository.update(
            oldFCMToken: existingToken,
            newFCMToken: newToken
        )
    }
    
}
