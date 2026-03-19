//
//  Bundle+URL.swift
//  KNToken
//
//  Created by 이정훈 on 1/3/26.
//

import Foundation

private class KNTokenBundleFinder {}

public extension Bundle {
    static var knToken: Bundle {
        let framworkBundle = Bundle(for: KNTokenBundleFinder.self)
        let resource = "KNToken_KNToken.bundle"
        
        if let bundleURL = framworkBundle.resourceURL?.appendingPathComponent(resource),
           let bundle = Bundle(url: bundleURL) {
            return bundle
        }
        
        return framworkBundle
    }
    
    private var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var tokenURL: String? {
        guard let url = resource?["Token_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
}
