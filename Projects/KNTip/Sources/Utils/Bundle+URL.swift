//
//  Bundle+URL.swift
//  KNTip
//
//  Created by 이정훈 on 1/6/26.
//

import Foundation

extension Bundle {
    public static let knTip: Bundle = Bundle.module
    
    var resource: NSDictionary? {
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
