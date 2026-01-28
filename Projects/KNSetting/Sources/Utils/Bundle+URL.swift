//
//  Bundle+URL.swift
//  KNSetting
//
//  Created by 이정훈 on 1/28/26.
//

import Foundation

extension Bundle {
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
