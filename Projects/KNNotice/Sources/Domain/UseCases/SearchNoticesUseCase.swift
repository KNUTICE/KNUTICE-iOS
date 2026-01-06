//
//  SearchNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/30/25.
//

import Factory
import Foundation

public protocol SearchNoticesUseCase: Actor {
    func execute(with keyword: String) async throws -> [Notice]
}

public actor SearchNoticesUseCaseImpl: SearchNoticesUseCase {
    @Injected(\.noticeRepository) private var repository
    
    public func execute(with keyword: String) async throws -> [Notice] {
        return try await repository.fetchNotices(keyword: keyword)
    }
}
