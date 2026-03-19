//
//  Bundle+URL.swift
//  KNReport
//
//  Created by 이정훈 on 1/6/26.
//

import Foundation

private class KNReportBundleFinder {}

public extension Bundle {
    static var knReport: Bundle {
        let frameworkBundle = Bundle(for: KNReportBundleFinder.self)
        let resource = "KNReport_KNReport.bundle"
        
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
    
    var reportURL: String? {
        guard let url = resource?["Report_URL"] as? String else { return nil }
        
        return url
    }
}
