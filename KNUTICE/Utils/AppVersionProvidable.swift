//
//  AppVersionSearchable.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

protocol AppVersionProvidable {
    func getAppVersion() -> String
}

extension AppVersionProvidable {
    func getAppVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        
        return version + " beta 1"
    }
}
