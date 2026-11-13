//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import CorePresentation
import Foundation
import KNUtility

@MainActor
final class TabBarViewModel: BookmarkSortOptionProvidable {
    @Published var bookmarkSortOption: BookmarkSortOption = {
        let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.bookmarkSortOption.rawValue) ?? ""
        return BookmarkSortOption(rawValue: value) ?? .createdAtDescending
    }()
}
