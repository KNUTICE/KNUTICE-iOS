//
//  DeepLinkManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/23/25.
//

import Foundation

actor DeepLinkManager {
    static let shared = DeepLinkManager()
    
    private init() {}
    
    func extractNttId(from url: URL) -> Int? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItem = components.queryItems,
           let id = queryItem.first(where: { $0.name == "nttId" })?.value,
           let nttId = Int(id) {
            
            return nttId
        }
        
        return nil
    }
}
