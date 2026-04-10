//
//  AppVersionSearchable.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

public protocol AppVersionProvidable {
    func getAppVersion() -> String
}

public extension AppVersionProvidable {
    func getAppVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        
        #if DEBUG
        return version + " beta " + Bundle.knUtility.betaVersion
        #else
        return version
        #endif
    }
}
