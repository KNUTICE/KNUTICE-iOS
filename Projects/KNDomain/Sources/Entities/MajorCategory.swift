//
//  MajorCategory.swift
//  KNUTICEUtility
//
//  Created by 이정훈 on 9/9/25.
//

import Foundation
import KNUtility

/// Represents a major notice category.
public struct MajorCategory: CategoryProtocol, NoticeTabRepresentable {
    
    /// A unique integer identifier for the major.
    public let id: Int
    
    /// The localized display name of the major.
    public let localizedDescription: String
    
    /// The legacy string-based topic identifier used by the server and internal logic.
    ///
    /// - Note: Retained for backward compatibility. Prefer using `id` for new implementations.
    @available(iOS, deprecated: 17.0, message: "Use id instead")
    @available(macCatalyst, deprecated: 17.0, message: "Use id instead")
    public let topic: String
    
    /// The name of the college to which this major belongs.
    public let college: String
    
    /// The title displayed in the notice tab.
    public var tabTitle: String { localizedDescription }
    
    public init(id: Int, localizedDescription: String, topic: String, college: String) {
        self.id = id
        self.localizedDescription = localizedDescription
        self.topic = topic
        self.college = college
    }
}
