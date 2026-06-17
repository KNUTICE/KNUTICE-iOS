//
//  TokenRepository.swift
//  KNToken
//
//  Created by 이정훈 on 1/27/26.
//

import Foundation

public protocol TokenRepository: Actor {
    /// Registers a newly generated FCM token with the backend server.
    ///
    /// This method is typically called during the initial app launch or when a user
    /// first grants notification permissions.
    ///
    /// - Throws: An error if the network request fails or if the server rejects the registration.
    func register() async throws
    
    /// Updates the server with a new FCM token while providing the previous token for identification.
    ///
    /// Use this method when Firebase refreshes the device token. Providing the `oldFCMToken`
    /// allows the server to replace the outdated record accurately, maintaining data integrity.
    ///
    /// - Parameters:
    ///   - oldFCMToken: The previous token stored in the local secure storage (Keychain).
    ///     Can be `nil` if no previous token exists.
    ///   - newFCMToken: The refreshed FCM token to be used for future notifications.
    /// - Throws: An error if the update process fails, such as due to network instability
    ///   or invalid token formats.
    func update(oldFCMToken: String?, newFCMToken: String) async throws
}
