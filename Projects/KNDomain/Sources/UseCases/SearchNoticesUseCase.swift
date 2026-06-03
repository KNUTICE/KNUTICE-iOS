//
//  SearchNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Foundation

public protocol SearchNoticesUseCase: Actor {
    func execute(with keyword: String) async throws -> [Notice]
}

public actor SearchNoticesUseCaseImpl: SearchNoticesUseCase {
    private let noticeRepository: NoticeRepository
    
    public init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    public func execute(with keyword: String) async throws -> [Notice] {
        return try await noticeRepository.fetchNotices(keyword: keyword)
    }
}
