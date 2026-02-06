//
//  FetchNoticeSummaryUseCase.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/29/26.
//

import Factory
import Foundation
import KNMarkdown

protocol FetchNoticeSummaryUseCase: Actor {
    func execute(for nttId: Int) async throws -> [MarkdownNode]
}

actor FetchNoticeSummaryUseCaseImpl: FetchNoticeSummaryUseCase {
    @Injected(\.noticeSummaryRepository) private var repository
    
    func execute(for nttId: Int) async throws -> [MarkdownNode] {
        try Task.checkCancellation()
        
        let noticeSummary = try await repository.fetch(for: nttId)
        let nodes = MarkdownParser.parse(noticeSummary.content)
        
        return nodes
    }
    
    
}
