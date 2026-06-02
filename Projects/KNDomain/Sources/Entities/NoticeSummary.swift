//
//  NoticeSummary.swift
//  KNNoticeSummary
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

public struct NoticeSummary: Identifiable, Sendable {
    public let id: Int
    public let content: String
    
    public init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
}
