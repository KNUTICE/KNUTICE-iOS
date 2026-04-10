//
//  Bundle+URL.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 2/1/26.
//

import Foundation

private class KNReadingRoomBundleFinder {}

public extension Bundle {
    static var knReadingRoom: Bundle {
        let frameworkBundle = Bundle(for: KNReadingRoomBundleFinder.self)
        let resource = "KNReadingRoom_KNReadingRoom.bundle"
        
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
    
    var readingRoomStatusURL: String? {
        guard let url = resource?["Reading_Room_Status_URL"] as? String else { return nil }
        
        return url
    }
    
    var fcmTokenMethod: String {
        guard let url = resource?["FCMToken_Method"] as? String else { return "" }
        
        return url
    }
    
    var navigationMethod: String {
        guard let url = resource?["Navigation_Method"] as? String else { return "" }
        
        return url
    }
    
    var baseURL: String? {
        guard let url = resource?["Base_URL"] as? String else { return nil }
        
        return url
    }
}
