//
//  CategoryProtocol.swift
//  KNUTICECore
//
//  Created by 이정훈 on 10/29/25.
//

import Foundation

public protocol CategoryProtocol: Sendable {
    /// A localized, human-readable name of the category for display in the user interface.
    var localizedDescription: String { get }
    /// A legacy string identifier for the category.
    ///
    /// This property is deprecated and retained only for backward compatibility.
    /// Use the integer-based category identifier instead.
    @available(iOS, deprecated: 17.0)
    var topic: String { get }
}
