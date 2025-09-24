//
//  PushNoticeService.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/25/25.
//

import Factory
import Foundation
import KNUTICECore

/// A service that resolves a push payload (stored in UserDefaults) into a concrete `Notice`.
protocol PushNoticeService: Actor {
    /// Reads the stored push payload, resolves the deep link to an `nttId`,
    /// and fetches the corresponding `Notice`.
    /// - Returns: The fetched `Notice` if available; otherwise `nil`.
    func fetchPushNotice() async throws -> Notice?
}

/// Default implementation of `PushNoticeService`.
actor PushNoticeServiceImpl: PushNoticeService {
    // Encapsulate keys to avoid magic strings.
    private enum Keys {
        static let pushNotice = UserDefaultsKeys.pushNotice.rawValue
        static let deeplink = "deeplink"
    }
    
    @Injected(\.noticeRepository) private var noticeRepository: NoticeRepository

    func fetchPushNotice() async throws -> Notice? {
        // Read once and ensure cleanup regardless of early returns.
        guard let userInfo = UserDefaults.standard.dictionary(forKey: Keys.pushNotice) else {
            return nil
        }
        
        // Delete data after use
        defer { UserDefaults.standard.removeObject(forKey: Keys.pushNotice) }

        // Extract and validate deep link.
        guard let deepLinkStr = userInfo[Keys.deeplink] as? String,
              let deepLink = URL(string: deepLinkStr) else {
            return nil
        }

        // Resolve nttId from deep link.
        guard let nttId = await DeepLinkManager.shared.extractNttId(from: deepLink) else {
            return nil
        }

        // Fetch and return the notice.
        return try await noticeRepository.fetchNotice(by: nttId)
    }
}
