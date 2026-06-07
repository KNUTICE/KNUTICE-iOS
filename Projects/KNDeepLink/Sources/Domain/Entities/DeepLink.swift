//
//  DeepLink.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/24/25.
//

import Foundation
import KNDomain
import KNUtility

/// A type representing supported deep link destinations within the app.
public enum DeepLink: Sendable {
    
    /// Navigates to a specific notice.
    /// - Parameters:
    ///   - nttId: The unique identifier of the notice.
    ///   - contentUrl: An optional URL for the notice content.
    case notice(nttId: Int, contentUrl: URL?)
    
    /// Navigates to a specific cafeteria's meal plan.
    /// - Parameter cafeteria: The category of the cafeteria.
    case meal(cafeteria: CafeteriaCategory)
    
    /// Navigates to a bookmarked item.
    /// - Parameter nttId: The unique identifier of the bookmarked notice.
    case bookmark(nttId: Int)
    
    /// Navigates to a specific tab, optionally scrolling to an item within it.
    /// - Parameters:
    ///   - tabIndex: The index of the tab to display.
    ///   - itemIndex: The index of the item to scroll to within the tab. If `nil`, no item navigation occurs.
    case navigation(tabIndex: Int, itemIndex: Int? = nil)
    
    /// Navigates to a specific library reading room and seat.
    /// - Parameters:
    ///   - roomId: The unique identifier for the reading room.
    case readingRoom(roomId: String?)
    
    /// Represents an undefined or invalid deep link.
    case unknown
}
