//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/25.
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
        guard let resource, let url = resource["OpenSourceLicenseURL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var tokenURL: String? {
        guard let resource, let url = resource["Token_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var reportURL: String? {
        guard let resource, let url = resource["Report_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var notificationPermissionURL: String? {
        guard let resource, let url = resource["Notification_Permission_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var mainPopupContentURL: String? {
        guard let resource, let url = resource["Main_Popup_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var defaultThumbnailURL: String {
        guard let resource, let url = resource["DefaultThumbnail_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var tipURL: String? {
        guard let resource, let url = resource["TipURL"] as? String else {
            return nil
        }
        
        return url
    }
}
