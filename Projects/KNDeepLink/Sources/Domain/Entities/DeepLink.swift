//
//  DeepLink.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/24/25.
//

import Foundation
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
    
    /// Switches the app's main tab to a specific index.
    /// - Parameter tabIndex: The index of the tab to display.
    case navigation(tabIndex: Int)
    
    /// Navigates to a specific library reading room and seat.
    /// - Parameters:
    ///   - roomId: The unique identifier for the reading room.
    ///   - seatNum: The specific seat number.
    case readingRoom(roomId: String?, seat: String?)
    
    /// Represents an undefined or invalid deep link.
    case unknown
}
