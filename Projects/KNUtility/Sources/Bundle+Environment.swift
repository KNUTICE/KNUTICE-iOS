//
//  Bundle+Environment.swift
//  KNUtility
//
//  Created by 이정훈 on 4/6/26.
//

import Foundation

private class KNUtilityBundleFinder {}

extension Bundle {
    static var knUtility: Bundle {
        let framworkBundle = Bundle(for: KNUtilityBundleFinder.self)
        let resource = "KNUtility_KNUtility.bundle"
        
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
    
    var teamId: String {
        guard let teamId = resource?["Team_Id"] as? String else { return "" }
        
        return teamId
    }
    
    var betaVersion: String {
        guard let betaVersion = resource?["Beta_Version"] as? String else { return "" }
        
        return betaVersion
    }
}
