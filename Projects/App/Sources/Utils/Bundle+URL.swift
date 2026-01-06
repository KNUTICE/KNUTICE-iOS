//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/26.
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
    
    var defaultThumbnailURL: String {
        guard let url = resource?["DefaultThumbnail_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
}
