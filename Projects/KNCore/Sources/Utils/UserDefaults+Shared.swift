//
//  UserDefaults+Shared.swift
//  KNNotice
//
//  Created by 이정훈 on 1/5/26.
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
