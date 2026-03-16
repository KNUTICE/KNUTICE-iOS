//
//  Bundle+URL.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 2/1/26.
//

import Foundation

extension Bundle {
    static var knReadingRoom: Bundle { .module }
    
    var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var readingRoomStatusURL: String? {
        guard let url = resource?["Reading_Room_Status_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var bridgingMethod: String {
        guard let url = resource?["Bridging_Method"] as? String else {
            return ""
        }
        
        return url
    }
}
