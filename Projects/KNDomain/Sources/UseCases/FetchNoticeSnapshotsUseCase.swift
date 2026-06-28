//
//  FetchNoticeSnapshotsUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/1/25.
//

import Combine
import Foundation

public final class FetchNoticeSnapshotsUseCase: NoticeSnapshotCreatable, Sendable {
    private let noticeRepository: NoticeRepository
    
    public init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    /// Fetches notices for the specified category and converts them into `NoticeSnapshot`s
    /// by applying business rules such as determining whether a notice is new.
    ///
    /// - Parameters:
    ///   - category: The notice category to fetch.
    ///   - nttId: The identifier of the last fetched notice for pagination.
    ///   - size: The maximum number of notices to fetch.
    /// - Returns: An array of `NoticeSnapshot`s enriched with business-specific state.
    /// - Throws: An error if the fetch operation fails or the task is cancelled.
    public func execute(
        category: some CategoryProtocol,
        after nttId: Int? = nil,
        size: Int = 20
    ) async throws -> [NoticeSnapshot] {
        try Task.checkCancellation()
        
        // Fetch notices from the repository.
        let notices = try await noticeRepository.fetchNotices(for: category.topic, after: nttId, size: size)
        // Apply business rules and convert notices into snapshots.
        let snapshots = notices.map { createSnapshot(from: $0) }
        
        return snapshots
    }
    
    /// Fetches notices for the specified category and converts them into `NoticeSnapshot`s
    /// using a Combine publisher.
    ///
    /// The returned publisher applies business rules such as determining whether
    /// a notice is new and transforms each `Notice` into a corresponding
    /// `NoticeSnapshot`.
    ///
    /// - Parameters:
    ///   - category: The notice category to fetch.
    ///   - nttId: The identifier of the last fetched notice for pagination.
    ///   - size: The maximum number of notices to fetch.
    /// - Returns: A publisher that emits an array of `NoticeSnapshot`s enriched
    ///   with business-specific state, or fails with an error.
    public func execute(
        category: some CategoryProtocol,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[NoticeSnapshot], any Error> {
        return noticeRepository.fetchNotices(for: category.topic, after: nttId, size: size)
            .map { [weak self] notices in
                notices.compactMap { self?.createSnapshot(from: $0) }
            }
            .eraseToAnyPublisher()
    }
    
}
