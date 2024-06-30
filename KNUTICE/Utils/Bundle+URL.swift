//
//  Bundle+URL.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

extension Bundle {
    var url: String {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let url = resource["API_URL"] as? String else {
            return ""
        }
        
        return url
    }
}
