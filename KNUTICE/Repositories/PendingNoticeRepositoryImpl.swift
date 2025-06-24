//
//  PendingNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/16/25.
//

import Factory
import Foundation

final class PendingNoticeRepositoryImpl: PendingNoticeRepository {
    @Injected(\.pendingNoticeDataSource) private var dataSource
    
    func fetchAll() async throws -> [Int] {
        try Task.checkCancellation()
        
        return try await dataSource.fetchAll()
    }
    
    func delete(id: Int) async throws {
        try Task.checkCancellation()
        
        try await dataSource.delete(withId: id)
    }
}
