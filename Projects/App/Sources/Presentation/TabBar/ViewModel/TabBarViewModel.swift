//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import CorePresentation
import Factory
import Foundation
import KNDeepLink
import KNUtility
import os

@MainActor
final class TabBarViewModel: BookmarkSortOptionProvidable {
    @Published var category: MajorCategory? = nil
    @Published var bookmarkSortOption: BookmarkSortOption = {
        let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.bookmarkSortOption.rawValue) ?? ""
        return BookmarkSortOption(rawValue: value) ?? .createdAtDescending
    }()
    
    init(category: MajorCategory?) {
        self.category = category
    }
    
}
