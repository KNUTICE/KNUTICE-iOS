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
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error> {
        return Deferred {
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
        }
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error> {
        return fetchNotices(for: category)
    }
    
    func fetchNotices(for category: NoticeCategory, size: Int) async throws -> [Notice] {
        let notices: [Notice]
        
        switch category {
        case .generalNotice:
            notices = Notice.generalNoticesSampleData
        case .academicNotice:
            notices = Notice.academicNoticesSampleData
        case .scholarshipNotice:
            notices = Notice.scholarshipNoticesSampleData
        case .eventNotice:
            notices = Notice.eventNoticesSampleData
        case .employmentNotice:
            notices = Notice.employmentNoticesSampleData
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
