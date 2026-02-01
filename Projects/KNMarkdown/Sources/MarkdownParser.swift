//
//  MarkdownParser.swift
//  KNMarkDown
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

public struct MarkdownParser {
    public static func parse(_ markdown: String) -> [MarkdownNode] {
        var lines = markdown.components(separatedBy: .newlines)
        var nodes: [MarkdownNode] = []
        
        while !lines.isEmpty {
            let line = lines.removeFirst().trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }
            
            // Heading 파싱
            if line.hasPrefix("#") {
                nodes.append(parseHeading(line))
            }
            
            // Table 파싱
            else if line.hasPrefix("|") {
                if !lines.isEmpty && hasTableSeparator(lines.first ?? "") {
                    let headers = parseTableRow(line)    // 첫 줄은 헤더
                    lines.removeFirst()    // 구분선 제거
                    
                    var rows = [[String]]()
                    while !lines.isEmpty && lines.first?.trimmingCharacters(in: .whitespaces).hasPrefix("|") == true {
                        let rowData = lines.removeFirst()
                        rows.append(parseTableRow(rowData))
                    }
                    
                    nodes.append(.table(headers: headers, rows: rows))
                } else {
                    nodes.append(.paragraph(text: line))
                }
            }
            
            // List item 파싱
            else if line.hasPrefix("* ") || line.hasPrefix("- ") {
                let content = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
                nodes.append(.listItem(text: String(content)))
            }
            
            // 일반 텍스트
            else {
                nodes.append(.paragraph(text: line))
            }
        }
        
        return nodes
    }
    
    private static func parseHeading(_ line: String) -> MarkdownNode {
        let level = line.prefix(while: { $0 == "#" }).count
        let content = line.dropFirst(level).trimmingCharacters(in: .whitespaces)
        return .heading(text: content, level: level)
    }
    
    private static func hasTableSeparator(_ line: String) -> Bool {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        return trimmed.hasPrefix("|") && trimmed.contains("-")
    }
    
    private static func parseTableRow(_ line: String) -> [String] {
        // 양끝의 | 를 제거하고 분리
        return line.trimmingCharacters(in: CharacterSet(charactersIn: "| "))
            .components(separatedBy: "|")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
