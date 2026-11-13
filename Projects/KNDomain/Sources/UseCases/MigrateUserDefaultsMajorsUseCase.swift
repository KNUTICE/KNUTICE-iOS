import Foundation
import KNUtility

/// Converts the selected major's legacy topic strings to integer topic identifiers.
public actor MigrateUserDefaultsMajorsUseCase {
    public enum MigrationError: Error {
        case unknownTopic(String)
        case ambiguousTopic(String)
        case invalidMajorID(Int)
    }

    private let repository: TopicRepository
    private var migrationTask: Task<Void, Error>?

    public init(repository: TopicRepository) {
        self.repository = repository
    }

    public func execute() async throws {
        if let migrationTask {
            try await migrationTask.value
            return
        }

        let task = Task { try await performMigration() }
        migrationTask = task
        defer { migrationTask = nil }
        try await task.value
    }

    private func performMigration() async throws {
        guard let legacyTopics = await MajorManager.shared.legacyTopicsForMigration() else {
            return
        }

        var ids: [Int] = []
        if !legacyTopics.isEmpty {
            let categories = try await repository.getAllTopics(for: .major)
                .compactMap { $0 as? MajorCategory }

            for topic in legacyTopics {
                let matchingIDs = Set(categories.filter { $0.topic == topic }.map(\.id))
                guard let id = matchingIDs.first else {
                    throw MigrationError.unknownTopic(topic)
                }
                guard matchingIDs.count == 1 else {
                    throw MigrationError.ambiguousTopic(topic)
                }
                guard id > 0, NoticeCategory(id: id) == nil, CafeteriaCategory(id: id) == nil else {
                    throw MigrationError.invalidMajorID(id)
                }
                if !ids.contains(id) {
                    ids.append(id)
                }
            }
        }

        try Task.checkCancellation()
        try await MajorManager.shared.completeLegacyMigration(expectedTopics: legacyTopics, ids: ids)
    }
}
