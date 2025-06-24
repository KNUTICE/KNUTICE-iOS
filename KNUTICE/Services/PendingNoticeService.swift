//
//  PendingNoticeService.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/16/25.
//

import Factory
import Foundation

protocol PendingNoticeService {
    /// Fetches all pending notices by retrieving their IDs from `pendingNoticeRepository`
    /// and then fetching the actual notices concurrently from `noticeRepository`.
    ///
    /// - Returns: A `Result` containing an array of `Notice` on success, or an `Error` on failure.
    /// - Note: This method performs concurrent fetching using `withThrowingTaskGroup`.
    ///         If any of the tasks fail, the entire operation fails.
    func fetchPendingNotices() async -> Result<[Notice], any Error>
}

final class PendingNoticeServiceImpl: PendingNoticeService {
    @Injected(\.noticeRepository) private var noticeRepository
    @Injected(\.pendingNoticeRepository) private var pendingNoticeRepository
    
    func fetchPendingNotices() async -> Result<[Notice], any Error> {
        guard !Task.isCancelled else {
            return .failure(CancellationError())
        }
        
        do {
            let nttIds = try await pendingNoticeRepository.fetchAll()
            var notices = [Notice]()
            try await withThrowingTaskGroup(of: Notice?.self) { group in
                for nttId in nttIds {
                    group.addTask {
                        return try await self.noticeRepository.fetchNotice(by: nttId)
                    }
                }
                
                for try await notice in group {
                    if let notice = notice {
                        notices.append(notice)
                    }
                }
            }
            
            return .success(notices)
        } catch {
            return .failure(error)
        }
    }
}
