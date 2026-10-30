//
//  FetchMajorCategoriesUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 7/7/26.
//

import Foundation

public final class FetchMajorCategoriesUseCase: Sendable {
    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [String: [MajorCategory]] {
        let categories = try await repository.getAllTopics(for: .major)
        let majorCategories = categories.compactMap { $0 as? MajorCategory }
        
        return Dictionary(grouping: majorCategories, by: \.college)
    }
}
