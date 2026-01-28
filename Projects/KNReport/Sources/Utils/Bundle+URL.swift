//
//  Bundle+URL.swift
//  KNReport
//
//  Created by 이정훈 on 1/6/26.
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
    
    var reportURL: String? {
        guard let url = resource?["Report_URL"] as? String else { return nil }
        
        return url
    }
}
