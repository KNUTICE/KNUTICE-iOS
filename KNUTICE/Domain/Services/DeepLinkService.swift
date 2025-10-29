//
//  PushNoticeService.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/25/25.
//

import Factory
import Foundation
import KNUTICECore

/// A service that resolves a stored push payload into a `DeepLink`.
protocol DeepLinkService: Actor {
    /// Retrieves and resolves the push payload saved in `UserDefaults`.
    ///
    /// - Returns: A valid `DeepLink` if one exists, or `.unknown` if no payload
    ///   is available or the value is invalid.
    func fetchDeepLink() async throws -> DeepLink
}

/// Default implementation of `DeepLinkService`.
actor DeepLinkServiceImpl: DeepLinkService {
    // Encapsulate keys to avoid magic strings.
    private enum Keys {
        static let userInfo = UserDefaultsKeys.userInfo.rawValue
        static let deeplink = "deeplink"
    }

    func fetchDeepLink() async throws -> DeepLink {
        // Read once and ensure cleanup regardless of early returns.
        guard let userInfo = UserDefaults.standard.dictionary(forKey: Keys.userInfo) else {
            return .unknown
        }
        
        // Delete data after use
        defer { UserDefaults.standard.removeObject(forKey: Keys.userInfo) }

        // Extract and validate deep link.
        guard let deepLinkStr = userInfo[Keys.deeplink] as? String,
              let url = URL(string: deepLinkStr) else {
            return .unknown
        }
        
        let deepLink = await DeepLinkManager.shared.parse(url)

        return deepLink
    }
}
