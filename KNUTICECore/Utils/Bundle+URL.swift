//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

public extension Bundle {
    static var standard: Bundle {
        return Bundle(for: RemoteDataSourceImpl.self)
    }
    
    var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var noticeURL: String? {
        guard let resource, let url = resource["Notice_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var tokenURL: String? {
        guard let resource, let url = resource["Token_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
