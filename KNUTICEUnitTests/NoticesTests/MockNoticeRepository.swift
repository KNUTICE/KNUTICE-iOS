//
//  MockNoticeRepository.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/9/25.
//

import Combine
import Foundation
import KNUTICECore

final class MockNoticeRepository: NoticeRepository {
    func fetchNotices(
        for category: String? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> {
        return Deferred {
            if let category, let category = NoticeCategory(rawValue: category) {
                if case .generalNotice = category {
                    return Just(Notice.generalNoticesSampleData)
                } else if case .academicNotice = category {
                    return Just(Notice.academicNoticesSampleData)
                } else if case .scholarshipNotice = category {
                    return Just(Notice.scholarshipNoticesSampleData)
                } else if case .eventNotice = category {
                    return Just(Notice.eventNoticesSampleData)
                } else {
                    return Just(Notice.employmentNoticesSampleData)
                }
            } else {
                return Just([])
            }
        }
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func fetchNotices(
        for category: String? = nil,
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
    
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error> {
        return Just(Notice.generalNoticesSampleData.first)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchNotice(by nttId: Int) async throws -> Notice? {
        return Notice.generalNoticesSampleData.first
    }
    
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error> {
        return Just(Notice.generalNoticesSampleData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
