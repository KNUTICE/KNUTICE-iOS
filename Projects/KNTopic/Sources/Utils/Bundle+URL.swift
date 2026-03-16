//
//  Bundle+URL.swift
//  KNTopic
//
//  Created by 이정훈 on 1/27/26.
//

import Foundation

private class KNTopicBundleFinder {}

public extension Bundle {
    static var knTopic: Bundle {
        let frameworkBundle = Bundle(for: KNTopicBundleFinder.self)
        
        // 프레임워크 번들 내부의 리소스 번들 탐색
        let bundleName = "KNTopic_KNTopic.bundle"
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(bundleName),
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
    
    var topicSubscriptionURL: String? {
        guard let url = resource?["TopicSubscription_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
