//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine

public protocol NoticeRepository: Sendable {
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error>
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error>
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error>
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error>
    func fetchNotice(by nttId: Int) async throws -> Notice?
    func fetchNotices(for category: NoticeCategory, size: Int) async throws -> [Notice]
}

public extension NoticeRepository {
    func fetchNotices(for category: NoticeCategory, size: Int = 20) async throws -> [Notice] {
        return try await self.fetchNotices(for: category, size: size)
    }
}
