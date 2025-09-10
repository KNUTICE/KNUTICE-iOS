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
    func fetchNotices<T>(
        for category: T,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> where T: RawRepresentable, T.RawValue == String {
        return Deferred {
            if let category = category as? NoticeCategory {
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
    
    func fetchNotices<T>(
        for category: T,
        after nttId: Int?,
        size: Int
    ) async throws -> [Notice] where T: RawRepresentable, T.RawValue == String {
        var notices = [Notice]()
        
        if let category = category as? NoticeCategory {
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
