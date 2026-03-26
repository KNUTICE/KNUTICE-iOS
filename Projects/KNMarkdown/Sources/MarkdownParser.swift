//
//  MarkdownParser.swift
//  KNMarkDown
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

public struct MarkdownParser {
    public static func parse(_ markdown: String) -> [MarkdownNode] {
        let lines = markdown.components(separatedBy: .newlines)
        var allNodes: [MarkdownNode] = []
        var i = 0
        
        while i < lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)
            
            if line.isEmpty {
                i += 1
                continue
            }
            
            // 1. Heading
            if line.hasPrefix("#") {
                allNodes.append(parseHeading(line))
                i += 1
            }
            
            // 2. Table
            else if line.hasPrefix("|") && i + 1 < lines.count && hasTableSeparator(lines[i + 1]) {
                let headers = parseTableRow(line)
                var rows = [[String]]()
                
                // 구분선 건너뛰고 데이터 row부터 시작 (i + 2)
                var j = i + 2
                while j < lines.count && lines[j].trimmingCharacters(in: .whitespaces).hasPrefix("|") {
                    rows.append(parseTableRow(lines[j]))
                    j += 1
                }
                
                allNodes.append(.table(headers: headers, rows: rows))
                i = j
            }
            
            // 3. List
            else if line.hasPrefix("* ") || line.hasPrefix("- ") {
                let (node, nextIndex) = parseList(lines, startIndex: i)
                allNodes.append(node)
                i = nextIndex
            }
            
            // 4. Paragraph
            else {
                allNodes.append(.paragraph(text: line))
                i += 1
            }
        }
        
        return allNodes
    }
}

// MARK: - Heading
extension MarkdownParser {
    private static func parseHeading(_ line: String) -> MarkdownNode {
        let level = line.prefix(while: { $0 == "#" }).count
        let content = line.dropFirst(level).trimmingCharacters(in: .whitespaces)
        return .heading(text: content, level: level)
    }
}

// MARK: - Table
extension MarkdownParser {
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

// MARK: - List
extension MarkdownParser {
    private static func parseList(_ lines: [String], startIndex: Int) -> (MarkdownNode, Int) {
        let line = lines[startIndex]
        let level = calculateLevel(line)
        let content = line.trimmingCharacters(in: .whitespaces).dropFirst(2).trimmingCharacters(in: .whitespaces)
        
        var child: [MarkdownNode] = []
        var currentIndex = startIndex + 1
        
        // 다음 줄들을 검사하며 들여쓰기가 더 깊은 아이템을 자식으로 수집
        while currentIndex < lines.count {
            let nextLine = lines[currentIndex]
            if nextLine.trimmingCharacters(in: .whitespaces).isEmpty {
                currentIndex += 1
                continue
            }
            
            let nextLevel = calculateLevel(nextLine)
            
            // 들여쓰기가 현재보다 깊으면 자식 노드임
            if nextLevel > level && (nextLine.trimmingCharacters(in: .whitespaces).hasPrefix("* ") || nextLine.trimmingCharacters(in: .whitespaces).hasPrefix("- ")) {
                let (childNode, nextIdx) = parseList(lines, startIndex: currentIndex)
                child.append(childNode)
                currentIndex = nextIdx
            } else {
                // 들여쓰기가 같거나 낮아지면 현재 리스트 depth 종료
                break
            }
        }
        
        return (.listItem(text: String(content), level: level, child: child), currentIndex)
    }
    
    private static func calculateLevel(_ line: String) -> Int {
        let initialSpaces = line.prefix(while: { $0 == " " }).count
        return initialSpaces / 4 // 공백 4개를 1단계 레벨로 가정
    }
}
