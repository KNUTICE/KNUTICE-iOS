//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

extension Bundle {
    var mainNoticeURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Main_Notice_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var generalNoticeURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["General_Notice_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var academicNoticeURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Academic_Notice_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var scholarshipNoticeURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Scholarship_Notice_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var eventNoticeURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Event_Notice_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var openSourceURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["OpenSourceLicenseURL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var tokenURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Token_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var reportURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Report_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var searchURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Search_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var notificationPermissionURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Notification_Permission_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var mainPopupContentURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Main_Popup_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
    var noticeSyncURL: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["Notice_Sync_URL"] as? String else {
            return ""
        }
        
        return url
    }
}
