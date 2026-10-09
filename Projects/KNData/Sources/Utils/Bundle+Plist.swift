//
//  Bundle+Plist.swift
//  KNData
//
//  Created by 이정훈 on 4/28/26.
//

import Foundation

private class KNDataBundleFinder {}

extension Bundle {
    public static var knData: Bundle {
        let frameworkBundle = Bundle(for: KNDataBundleFinder.self)
        let resource = "KNData_KNData.bundle"
        
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(resource),
           let bundle = Bundle(url: bundleURL) {
            return bundle
        }
        
        return frameworkBundle
    }
    
    private var resource: NSDictionary? {
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
    
    var reportURL: String? {
        guard let url = resource?["Report_URL"] as? String else { return nil }
        
        return url
    }
    
    var tipURL: String? {
        guard let url = resource?["TipURL"] as? String else { return nil }
        
        return url
    }
    
    var topicURLV1: String? {
        guard let url = resource?["Topic_URL_V1"] as? String else {
            return nil
        }
        
        return url
    }
    
    var topicURLV2: String? {
        guard let url = resource?["Topic_URL_V2"] as? String else {
            return nil
        }
        
        return url
    }
    
    var readingRoomURL: String? {
        guard let url = resource?["ReadingRoom_URL"] as? String else { return nil }
        
        return url
    }
    
    var noticeSummaryURL: String? {
        guard let url = resource?["Notice_Summary_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    public var tokenURL: String? {
        guard let url = resource?["Token_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
