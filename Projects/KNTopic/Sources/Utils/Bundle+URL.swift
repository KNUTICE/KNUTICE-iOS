//
//  Bundle+URL.swift
//  KNTopic
//
//  Created by 이정훈 on 1/27/26.
//

import Foundation

public extension Bundle {
    static var knTopic: Bundle { Bundle.module }
    
    private var resource: NSDictionary? {
        guard let file = self.path(forResource: "ServiceInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var topicSubscriptionURL: String? {
        guard let url = resource?["TopicSubscription_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
