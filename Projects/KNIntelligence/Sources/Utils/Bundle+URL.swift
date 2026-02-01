//
//  Bundle+URL.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

extension Bundle {
    var resource: NSDictionary? {
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
