//
//  Tip.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Foundation

public struct Tip: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let contentURL: String
    
    public init(id: String, title: String, contentURL: String) {
        self.id = id
        self.title = title
        self.contentURL = contentURL
    }
}
