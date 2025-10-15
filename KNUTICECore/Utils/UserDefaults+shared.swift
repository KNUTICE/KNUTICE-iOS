//
//  UserDefaults+shared.swift
//  KNUTICECore
//
//  Created by 이정훈 on 10/15/25.
//

import Foundation

public extension UserDefaults {
    /// A shared `UserDefaults` instance that allows data sharing
    /// between the main app and its extensions using an App Group.
    static var shared: UserDefaults? {
        let groupId = "group.com.fx.KNUTICE"
        return UserDefaults(suiteName: groupId)
    }
}
