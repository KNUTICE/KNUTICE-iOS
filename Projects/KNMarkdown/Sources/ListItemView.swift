//
//  ListItemView.swift
//  KNMarkdown
//
//  Created by 이정훈 on 2/4/26.
//

import SwiftUI

public struct ListItemView: View {
    private let content: String
    private let level: Int
    private let children: [MarkdownNode]
    
    public init(content: String, level: Int, children: [MarkdownNode]) {
        self.content = content
        self.level = level
        self.children = children
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 현재 레벨의 아이템
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(bulletPoint(for: level))
                    .font(.system(size: 14, weight: .bold))
                
                Text(.init(content))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // 자식 노드
            if !children.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(children) { child in
                        if case let .listItem(childContent, childLevel, childChildren) = child {
                            ListItemView(content: childContent, level: childLevel, children: childChildren)
                        }
                    }
                }
                .padding(.leading, 15) // 들여쓰기 적용
            }
        }
    }
    
    // 레벨에 따라 불렛 모양 변경
    private func bulletPoint(for level: Int) -> String {
        return level % 2 == 0 ? "•" : "◦"
    }
}

#Preview {
    ListItemView(content: "Hello World!", level: 0, children: [
        .listItem(text: "Hello World!", level: 1, child: [])
    ])
}
