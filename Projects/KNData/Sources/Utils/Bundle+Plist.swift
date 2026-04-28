//
//  Bundle+Plist.swift
//  KNData
//
//  Created by 이정훈 on 4/28/26.
//

import Foundation

private class KNDataBundleFinder {}

extension Bundle {
    static var knData: Bundle {
        let frameworkBundle = Bundle(for: KNDataBundleFinder.self)
        let resource = "knData_knData.bundle"
        
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
}
