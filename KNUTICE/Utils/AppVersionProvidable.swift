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
        
        #if DEV
        return version + " beta " + Bundle.main.betaVersion
        #else
        return version
        #endif
    }
}

fileprivate extension Bundle {
    var betaVersion: String {
        guard let resource, let version = resource["Beta_Version"] as? String else {
            return ""
        }
        
        return version
    }
}
