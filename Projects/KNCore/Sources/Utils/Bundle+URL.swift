//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

private class KNCoreBundleFinder {}

public extension Bundle {
    static var knCore: Bundle {
        let frameworkBundle = Bundle(for: KNCoreBundleFinder.self)
        let resource = "KNCore_KNCore.bundle"
        
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
    
    var defaultThumbnailURL: String {
        guard let url = resource?["DefaultThumbnail_URL"] as? String else {
            return ""
        }
        
        return url
    }
    
}
