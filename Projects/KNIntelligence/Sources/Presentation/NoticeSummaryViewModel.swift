//
//  NoticeSummaryViewModel.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/30/26.
//

import Factory
import Foundation
import KNMarkdown

@MainActor @Observable public class NoticeSummaryViewModel {
    private(set) var nodes: [MarkdownNode] = []
    private let nttId: Int
    
    @ObservationIgnored @Injected(\.fetchNoticeSummaryUseCase) private var fetchNoticeSummaryUseCase
    @ObservationIgnored private var allFetchedNodes: [MarkdownNode] = []
    
    public init(nttId: Int) { self.nttId = nttId }
    
    func fetch() async {
        do {
            let nodes = try await self.fetchNoticeSummaryUseCase.execute(for: self.nttId)
            self.allFetchedNodes = nodes
            self.nodes = []
            
            for node in allFetchedNodes {
                try? await Task.sleep(nanoseconds: 200_000_000) // 0.3초 대기 (속도 조절 가능)
                self.nodes.append(node)
            }
        } catch {
            print("NoticeSummaryViewModel.fetch() error: \(error)")
        }
    }
}
