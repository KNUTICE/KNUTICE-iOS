//
//  Bundle+URL.swift
//  KNMeal
//
//  Created by 이정훈 on 2/15/26.
//

import Foundation

private class KNMealBundleFinder {}

public extension Bundle {
    static var knMeal: Bundle {
        let frameworkBundle = Bundle(for: KNMealBundleFinder.self)
        let resource = "KNMeal_KNMeal.bundle"
        
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
    
    var baseURL: String {
        guard let resource, let baseURL = resource["Base_URL"] as? String else {
            return ""
        }
        
        return baseURL
    }
    
    var bridgingMethod: String {
        guard let url = resource?["Bridging_Method"] as? String else {
            return ""
        }
        
        return url
    }
}
