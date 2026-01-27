//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

public extension Bundle {
    var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var noticeURL: String? {
        guard let url = resource?["Notice_URL"] as? String else {
            return nil
        }
        
        return url
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
