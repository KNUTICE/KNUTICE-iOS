//
//  MarkdownTableView.swift
//  KNMarkdown
//
//  Created by 이정훈 on 1/29/26.
//

import KNDesignSystem
import SwiftUI

public struct MarkdownTableView: View {
    private let headers: [String]
    private let rows: [[String]]
    
    public init(headers: [String], rows: [[String]]) {
        self.headers = headers
        self.rows = rows
    }
    
    public var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 1) {
            // Header
            GridRow {
                ForEach(headers, id: \.self) { header in
                    Text(header)
                        .bold()
                        .font(.footnote)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding([.top, .bottom], 5)
                        .background(KNDesignSystemAsset.accent2.swiftUIColor)
                }
            }
            
            // Data
            ForEach(rows.indices, id: \.self) { index in
                GridRow {
                    ForEach(rows[index], id: \.self) { cell in
                        Text(cell)
                            .font(.footnote)
                            .padding([.top, .bottom], 8)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .background(.gray.opacity(0.1))
        .cornerRadius(7)
    }
}

#Preview {
    MarkdownTableView(
        headers: [
            "회차", "일정", "분야", "현직자 소속"
        ],
        rows: [
            ["1", "1.5.(월) 19:00~21:00", "SW 개발", "00테크"],
            ["2", "1.6.(화) 19:00~21:00", "기계직", "00시설관리공단"],
        ]
    )
}
