//
//  DeepLinkManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/23/25.
//

import Foundation
import KNUtility

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
            let topic = queryItems?.first(where: { $0.name == "topic" })?.value
            
            guard let topic, let cafeteria = CafeteriaCategory(rawValue: topic) else { return .unknown }
            
            return .meal(cafeteria: cafeteria)
            
        case "bookmark":
            let nttIdValue = queryItems?.first(where: { $0.name == "nttId" })?.value
            
            if let nttIdValue, let nttId = Int(nttIdValue) {
                return .bookmark(nttId: nttId)
            }
            
            return .unknown
            
        case "reading-room":
            guard let roomId = queryItems?.first(where: { $0.name == "roomId" })?.value,
                  let seat = queryItems?.first(where: { $0.name == "seat" })?.value else {
                return .unknown
            }
            return .readingRoom(roomId: roomId, seat: seat)
            
        default:
            return .unknown
        }
    }
}
