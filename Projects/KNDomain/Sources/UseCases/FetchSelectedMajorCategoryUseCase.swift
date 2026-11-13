//
//  FetchSelectedMajorCategoryUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 7/7/26.
//

import Foundation
import KNUtility

/// A use case that retrieves the user's currently selected major category.
public final class FetchSelectedMajorCategoryUseCase: Sendable {
    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    /// Retrieves the currently selected major category.
    ///
    /// This method reads the selected major identifier from local storage and
    /// fetches the corresponding `MajorCategory` from the repository.
    ///
    /// - Returns: The selected `MajorCategory` if available; otherwise, `nil`.
    /// - Throws: An error if the repository request fails.
    public func execute() async throws -> MajorCategory? {
        guard let majorID = await MajorManager.shared.majorIDs.first else { return nil }
        
        let categories = try await repository.getTopics(id: majorID)
        
        guard let category = categories.first else { return nil }
        
        return category as? MajorCategory
    }
}
