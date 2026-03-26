//
//  Bundle+URL.swift
//  KNTip
//
//  Created by 이정훈 on 1/6/26.
//

import Foundation

private class KNTipBundleFinder {}

public extension Bundle {
    static var knTip: Bundle {
        let frameworkBundle = Bundle(for: KNTipBundleFinder.self)
        let resource = "KNTip_KNTip.bundle"
        
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
    
    var tipURL: String? {
        guard let url = resource?["TipURL"] as? String else { return nil }
        
        return url
    }
}
