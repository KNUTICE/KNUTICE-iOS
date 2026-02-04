//
//  MarkDownNode.swift
//  KNMarkDown
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

public enum MarkdownNode: Identifiable, Equatable, Sendable {
    case heading(text: String, level: Int)
    case paragraph(text: String)
    case listItem(text: String)
    case table(headers: [String], rows: [[String]])
    
    public var id: UUID { UUID() }
}
