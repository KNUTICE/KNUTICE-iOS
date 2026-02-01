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
    
    public init(nttId: Int) { self.nttId = nttId }
    
    func fetch() async {
        do {
            let nodes = try await self.fetchNoticeSummaryUseCase.execute(for: self.nttId)
            self.nodes = nodes
        } catch {
            print("NoticeSummaryViewModel.fetch() error: \(error)")
        }
    }
}
