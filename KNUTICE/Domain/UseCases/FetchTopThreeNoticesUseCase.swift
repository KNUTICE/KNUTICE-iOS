//
//  FetchTopThreeNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/29/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore

protocol FetchTopThreeNoticesUseCase: Sendable {
    /// Fetches notices for all `NoticeCategory` cases concurrently and returns them as `[MainSectionNotice]`.
    ///
    /// This method performs the following tasks:
    /// 1. Fetches notices for each category concurrently using `Publishers.MergeMany`.
    /// 2. Maps the results into `MainSectionNotice` objects with the actual notices.
    /// 3. Ensures the returned array preserves the order of `NoticeCategory.allCases`.
    ///
    /// If `isRefresh` is `false`, the method first emits mock notices (skeleton UI)
    /// using `.prepend(getMockNotices())` to provide immediate placeholder data before the actual network data arrives.
    ///
    /// - Parameter isRefresh: A boolean indicating whether this fetch is triggered by a refresh action.
    ///                        If `true`, only actual notices are emitted without skeleton placeholders.
    /// - Returns:
    ///   An `AnyPublisher` that emits:
    ///   1. An initial array of mock `MainSectionNotice` values (if `isRefresh == false`) for loading state, and
    ///   2. The actual array of notices fetched from the server once all requests complete.
    ///   The publisher may fail with an error if any fetch operation fails.
    func execute(isRefresh: Bool) -> AnyPublisher<[MainSectionNotice], any Error>
}

final class FetchTopThreeNoticesUseCaseImpl: FetchTopThreeNoticesUseCase {
    private let repository: NoticeRepository
    
    init(repository: NoticeRepository) {
        self.repository = repository
    }
    
    func execute(isRefresh: Bool) -> AnyPublisher<[MainSectionNotice], any Error> {
        let publishers = NoticeCategory.allCases.map { category in
            repository.fetchNotices(for: category.rawValue, size: 3)
                .map { notices -> (NoticeCategory, [Notice]) in (category, notices) }
                .eraseToAnyPublisher()
        }
        
        let mainSectionNoticePublishers = Publishers.MergeMany(publishers)
            .collect()
            .map { results in
                // Convert to dictionary for easy access
                var sectionNotices: [NoticeCategory: MainSectionNotice] = [:]
                
                for (category, notices) in results {
                    let sectionNotice = MainSectionNotice(
                        header: category.localizedDescription,
                        items: notices.map { MainNotice(presentationType: .actual, notice: $0) }
                    )
                    sectionNotices[category] = sectionNotice
                }
                
                // Ensure order follows NoticeCategory.allCases
                return NoticeCategory.allCases.map { category in
                    sectionNotices[category, default: MainSectionNotice(header: "", items: [])]
                }
            }
            .eraseToAnyPublisher()
        
        return Deferred { [weak self] in
            if isRefresh {
                return mainSectionNoticePublishers
                    .eraseToAnyPublisher()
            }
            
            return mainSectionNoticePublishers
                .prepend(self?.getMockNotices() ?? [])    // 로딩 중 Skeleton 화면을 표시하기 위한 임시 데이터 전달
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    /// Generates mock notice data for displaying a skeleton loading UI.
    ///
    /// This method creates a placeholder list of `MainSectionNotice` objects for all `NoticeCategory` cases.
    /// Each section uses mock notices configured with the `.skeleton` presentation type,
    /// allowing the UI to display a consistent loading state before actual data is fetched.
    ///
    /// - Returns:
    ///   An array of `MainSectionNotice` objects containing mock notices for each category.
    ///   Intended to be used as placeholder data during loading states.
    private func getMockNotices() -> [MainSectionNotice] {
        NoticeCategory.allCases.map { category in
            MainSectionNotice(
                header: category.localizedDescription,
                items: Notice.mockNotices.map { MainNotice(presentationType: .skeleton, notice: $0) }
            )
        }
    }
    
}

fileprivate extension Notice {
    static var mockNotices: [Self] {
        (0..<3).map { _ in
            Notice(
                id: UUID().hashValue,
                title: " ",
                contentUrl: " ",
                department: " ",
                uploadDate: " ",
                imageUrl: nil,
                noticeCategory: nil
            )
        }
    }
}
