//
//  FetchNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/1/25.
//

import Combine
import Factory
import Foundation
import KNTopic
import KNUtility

public protocol FetchNoticesUseCase: Actor {
    /// Fetches notices for the specified category and updates related user settings if necessary.
    ///
    /// - Parameters:
    ///   - category: The notice category to fetch, conforming to `CategoryProtocol`.
    ///   - nttId: The ID of the last fetched notice, used for pagination. Pass `nil` to fetch the latest notices.
    ///   - size: The number of notices to fetch per request.
    /// - Returns: An array of `Notice` objects fetched from the server.
    /// - Throws: An error if the task is cancelled or fetching notices from the repository fails.
    func execute(category: some CategoryProtocol, after nttId: Int?, size: Int) async throws -> [Notice]
}

public extension FetchNoticesUseCase {
    func execute(category: some CategoryProtocol, after nttId: Int? = nil, size: Int = 20) async throws -> [Notice] {
        try await self.execute(category: category, after: nttId, size: size)
    }
}

public actor FetchNoticesUseCaseImpl: FetchNoticesUseCase, UploadDateComparable {
    @Injected(\.noticeRepository) private var noticeRepository
    
    public func execute(category: some CategoryProtocol, after nttId: Int?, size: Int) async throws -> [Notice] {
        try Task.checkCancellation()
        
        // 서버에서 선택된 공지 데이터 가져오기
        var notices = try await noticeRepository.fetchNotices(for: category.rawValue, after: nttId, size: size)
        
        // 업로드 날짜 기준 24시간 이내 여부 확인
        for i in notices.indices {
            guard isWithin24Hours(from: notices[i].uploadDate) else { break }
            
            notices[i].isNew = true
        }
        
        return notices
    }
    
}
