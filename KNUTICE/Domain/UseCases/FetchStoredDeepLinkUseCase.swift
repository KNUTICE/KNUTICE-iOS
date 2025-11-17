//
//  FetchStoredDeepLinkUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/2/25.
//

import Foundation
import KNUTICECore

protocol FetchStoredDeepLinkUseCase: Actor {
    /// Fetches and resolves a stored deep link from UserDefaults.
    ///
    /// This method retrieves the temporary user info stored under `UserDefaultsKeys.userInfo`,
    /// attempts to extract a deep link URL, and parses it into a `DeepLink` domain model.
    /// The stored data is removed automatically after the method executes, regardless of the outcome.
    ///
    /// - Returns: A resolved `DeepLink` if a valid deep link URL exists; otherwise, `.unknown`.
    /// - Throws: May rethrow errors that occur during deep link parsing.
    ///
    /// - Note: This use case processes only one stored deep link at a time.
    func execute() async throws -> DeepLink
}

actor FetchStoredDeepLinkUseCaseImpl: FetchStoredDeepLinkUseCase {
    func execute() async throws -> DeepLink {
        // Delete data after use
        defer { UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userInfo.rawValue) }
        
        // Read once and ensure cleanup regardless of early returns.
        guard let userInfo = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userInfo.rawValue) else {
            return .unknown
        }
        
        // Extract and validate deep link.
        guard let deepLinkStr = userInfo[UserInfoKeys.deepLink.rawValue] as? String,
              let url = URL(string: deepLinkStr) else {
            return .unknown
        }
        
        let deepLink = await DeepLinkManager.shared.parse(url)

        return deepLink
    }
}
