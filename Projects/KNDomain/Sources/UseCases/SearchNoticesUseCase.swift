//
//  SearchNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Foundation

public final class SearchNoticeSnapshotsUseCase: NoticeSnapshotCreatable, Sendable {
    private let noticeRepository: NoticeRepository
    
    public init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    public func execute(
        with keyword: String,
        after nttId: Int? = nil
    ) async throws -> [NoticeSnapshot] {
        let notices = try await noticeRepository.fetchNotices(keyword: keyword, after: nttId)
        
        return notices.map { createSnapshot(from: $0) }
    }
    
}
