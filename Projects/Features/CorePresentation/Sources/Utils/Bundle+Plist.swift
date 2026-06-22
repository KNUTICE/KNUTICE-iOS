//
//  Bundle+Plist.swift
//  CorePresentation
//
//  Created by 이정훈 on 4/29/26.
//

import Foundation

extension Bundle {
    private var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var defaultThumbnailURL: String {
        guard let url = resource?["DefaultThumbnail_URL"] as? String else { return "" }
        
        return url
    }
}
