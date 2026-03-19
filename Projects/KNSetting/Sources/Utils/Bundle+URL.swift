//
//  Bundle+URL.swift
//  KNSetting
//
//  Created by 이정훈 on 1/28/26.
//

import Foundation

private class KNSettingBundleFinder {}

public extension Bundle {
    static var knSetting: Bundle {
        let frameworkBundle = Bundle(for: KNSettingBundleFinder.self)
        let resource = "KNSetting_KNSetting.bundle"
        
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(resource),
           let bundle = Bundle(url: bundleURL) {
            return bundle
        }
        
        return frameworkBundle
    }
    
    var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var openSourceURL: String {
        guard let url = resource?["OpenSourceLicenseURL"] as? String else {
            return ""
        }
        
        return url
    }
}
