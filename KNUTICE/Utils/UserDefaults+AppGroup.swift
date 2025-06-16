//
//  UserDefaults+AppGroup.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/16/25.
//

import Foundation

extension UserDefaults {
    static let shared: UserDefaults = {
        let groupId = "group.com.fx.KNUTICE"
        return UserDefaults(suiteName: groupId) ?? UserDefaults.standard
    }()
}
