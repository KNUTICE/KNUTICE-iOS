//
//  Bundle+URL.swift
//  KNToken
//
//  Created by 이정훈 on 1/3/26.
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
    
    var tokenURL: String? {
        guard let url = resource?["Token_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
}
