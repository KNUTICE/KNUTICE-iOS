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
        
        #if DEV
        return version + " beta " + Bundle.main.betaVersion
        #else
        return version
        #endif
    }
}

fileprivate extension Bundle {
    private var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var betaVersion: String {
        guard let resource, let version = resource["Beta_Version"] as? String else {
            return ""
        }
        
        return version
    }
}
