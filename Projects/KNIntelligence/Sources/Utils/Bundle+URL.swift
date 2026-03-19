//
//  Bundle+URL.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

private class KNIntelligenceBundleFinder {}

public extension Bundle {
    static var knIntelligence: Bundle {
        let frameworkBundle = Bundle(for: KNIntelligenceBundleFinder.self)
        let resource = "KNIntelligence_KNIntelligence.bundle"
        
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
    
    var noticeSummaryURL: String? {
        guard let url = resource?["Notice_Summary_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
