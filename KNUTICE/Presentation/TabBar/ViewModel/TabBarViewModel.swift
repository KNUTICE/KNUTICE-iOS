//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore
import os

@MainActor
final class TabBarViewModel: BookmarkSortOptionProvidable {
    @Published var category: MajorCategory? = nil
    @Published var deepLink: DeepLink? = nil
    @Published var bookmarkSortOption: BookmarkSortOption = {
        let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.bookmarkSortOption.rawValue) ?? ""
        return BookmarkSortOption(rawValue: value) ?? .createdAtDescending
    }()
    
    init(category: MajorCategory?) {
        self.category = category
    }
    
    @Injected(\.fetchStoredDeepLinkUseCase) private var fetchStoredDeepLinkUseCase
    private let logger: Logger = Logger()
    private(set) var task: Task<Void, Never>?
    
    func fetchDeepLinkIfExists() {
        task = Task {
            do {
                self.deepLink = try await fetchStoredDeepLinkUseCase.execute()
            } catch {
                logger.error("TabBarViewModel.fetchPushNotice() error: \(error)")
            }
        }
    }
    
}
