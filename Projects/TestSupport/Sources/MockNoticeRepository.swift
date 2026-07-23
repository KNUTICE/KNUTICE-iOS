//
//  MockNoticeRepository.swift
//  TestSupport
//
//  Created by 이정훈 on 9/9/25.
//

import Combine
import KNDomain
import KNUtility

public final class MockNoticeRepository: NoticeRepository {
    public init() {}
    
    public func fetchNotices(
        for category: (any CategoryProtocol)? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> {
        return Deferred {
            if let category, let category = NoticeCategory(id: category.id) {
                if case .generalNotice = category {
                    return Just(Notice.generalNoticesSample)
                } else if case .academicNotice = category {
                    return Just(Notice.academicNoticesSample)
                } else if case .scholarshipNotice = category {
                    return Just(Notice.scholarshipNoticesSample)
                } else if case .eventNotice = category {
                    return Just(Notice.eventNoticesSample)
                } else {
                    return Just(Notice.employmentNoticesSample)
                }
            } else {
                return Just([])
            }
        }
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    public func fetchNotices(
        for category: (any CategoryProtocol)? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) async throws -> [Notice] {
        var notices = [Notice]()
        for try await result in fetchNotices(for: category, keyword: keyword, after: nttId, size: size).values {
            notices = result
        }
        
        return Array(notices.prefix(size))
    }
    
    public func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error> {
        return Just(Notice.generalNoticesSample.first)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func fetchNotice(by nttId: Int) async throws -> Notice? {
        return Notice.generalNoticesSample.first
    }
    
    public func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error> {
        return Just(Notice.generalNoticesSample)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
