//
//  DeepLinkManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/23/25.
//

import Foundation

public actor DeepLinkManager {
    public static let shared = DeepLinkManager()
    
    private init() {}
    
    public func parse(_ url: URL) -> DeepLink {
        guard let host = url.host else { return .unknown }
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        
        switch host {            
        case "notice", "widget":
            let nttIdValue = queryItems?.first(where: { $0.name == "nttId" })?.value
            let contentURL = queryItems?.first(where: { $0.name == "contentUrl" })?.value
            
            if let nttIdValue, let nttId = Int(nttIdValue) {
                return .notice(nttId: nttId, contentUrl: URL(string: contentURL ?? ""))
            }
            
            return .unknown
            
        case "meal":
            // TODO: 학식 알림 딥링크 구현
            return .unknown
            
        case "bookmark":
            let nttIdValue = queryItems?.first(where: { $0.name == "nttId" })?.value
            
            if let nttIdValue, let nttId = Int(nttIdValue) {
                return .bookmark(nttId: nttId)
            }
            
            return .unknown
            
        default:
            return .unknown
        }
    }
}
