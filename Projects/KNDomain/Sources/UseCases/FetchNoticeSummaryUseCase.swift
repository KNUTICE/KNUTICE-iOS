//
//  FetchNoticeSummaryUseCase.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation
import KNMarkdown

public protocol FetchNoticeSummaryUseCase: Sendable {
    func execute(for nttId: Int) async throws -> [MarkdownNode]
}

public final class FetchNoticeSummaryUseCaseImpl: FetchNoticeSummaryUseCase {
    private let repository: NoticeSummaryRepository
    
    public init(repository: NoticeSummaryRepository) {
        self.repository = repository
    }
    
    public func execute(for nttId: Int) async throws -> [MarkdownNode] {
        try Task.checkCancellation()
        
        let noticeSummary = try await repository.fetch(for: nttId)
        let nodes = MarkdownParser.parse(noticeSummary.content)
        
        return nodes
    }
    
    
}
