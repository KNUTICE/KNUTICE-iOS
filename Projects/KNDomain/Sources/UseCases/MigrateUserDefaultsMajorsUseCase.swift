//
//  MigrateUserDefaultsMajorsUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 7/8/26.
//

import Foundation
import KNUtility

/// Migrates legacy major names stored in `UserDefaults` to topic identifiers.
public final class MigrateUserDefaultsMajorsUseCase: Sendable {
    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    /// Fetches topic data for saved major names and stores matching major identifiers.
    public func execute() async throws {
        let majorTopics = await MajorManager.shared.majorStrings
        
        try await withThrowingTaskGroup(of: [any CategoryProtocol].self) { group in
            for topic in majorTopics {
                group.addTask { [self] in
                    try await repository.getTopics(topic)
                }
            }
            
            for try await categories in group {
                for category in categories {
                    if let major = category as? MajorCategory {
                        await MajorManager.shared.add(id: major.id)
                    }
                }
            }
        }
        
        UserDefaults.shared?.set(true, forKey: UserDefaultsKeys.hasMigratedUserDefaultsMajors.rawValue)
    }
}
