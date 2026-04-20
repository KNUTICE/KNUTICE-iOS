//
//  NoticeTabViewModel.swift
//  KNCore
//
//  Created by 이정훈 on 4/10/26.
//

import Foundation
import KNUtility
import RxRelay

enum CategoryItem: Identifiable {
    /// A selectable notice category tab conforming to `NoticeTabRepresentable`.
    case category(any NoticeTabRepresentable)
    /// A fixed button cell for adding or managing notice categories.
    case addButton
    
    /// A stable identifier used to distinguish items in the collection view.
    var id: String {
        switch self {
        case let .category(noticeTab): return noticeTab.id
        case .addButton: return "add_button"
        }
    }
}

@MainActor
final class NoticeTabViewModel {
    /// The ordered list of category items displayed in the tab bar,
    /// including notice categories and the add button.
    let categories: BehaviorRelay<[CategoryItem]> = BehaviorRelay(value: [])
    
    /// The index of the currently selected category tab.
    let selectedIndex: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    /// A synchronous accessor for the current value of `categories`.
    var categoriesValue: [CategoryItem] {
        return categories.value
    }
    
    /// Initializes the view model and asynchronously loads the full category list.
    ///
    /// The loading order is:
    /// 1. All default `NoticeCategory` cases
    /// 2. Major-specific categories fetched from `MajorManager`
    /// 3. The add button appended at the end
    init() {
        Task {
            var value: [CategoryItem] = NoticeCategory.allCases.map { CategoryItem.category($0) }
            await MajorManager.shared.majorStrings.forEach {
                if let categoryItem = MajorCategory(rawValue: $0) {
                    value.append(.category(categoryItem))
                }
            }
            value.append(.addButton)
            categories.accept(value)
        }
    }
}
