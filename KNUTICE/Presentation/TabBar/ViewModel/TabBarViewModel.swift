//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import Factory
import KNUTICECore
import os

@MainActor
final class TabBarViewModel: ObservableObject {
    @Published var deepLink: DeepLink? = nil
    
    @Injected(\.pushNoticeService) private var service: DeepLinkService
    private let logger: Logger = Logger()
    private(set) var task: Task<Void, Never>?
    
    func fetchDeepLinkIfExists() {
        task = Task {
            do {
                self.deepLink = try await service.fetchDeepLink()
            } catch {
                logger.error("TabBarViewModel.fetchPushNotice() error: \(error)")
            }
        }
    }
    
}
