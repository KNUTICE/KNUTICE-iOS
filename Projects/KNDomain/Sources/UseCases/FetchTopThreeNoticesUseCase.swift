//
//  FetchTopThreeNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/29/25.
//

import Combine
import Foundation

public final class FetchTopThreeNoticesUseCase: NoticeSnapshotCreatable, Sendable {
    private let repository: NoticeRepository
    
    public init(repository: NoticeRepository) {
        self.repository = repository
    }
    
    /// Fetches the latest three notices for each notice category and converts them
    /// into `MainSectionNotice` objects for presentation.
    ///
    /// When `isRefresh` is `false`, skeleton data is emitted first to allow the UI
    /// to display a loading state while notice data is being fetched.
    ///
    /// - Parameter isRefresh:
    ///   A Boolean value indicating whether the request is triggered by a refresh action.
    ///   If `true`, only fetched data is emitted. If `false`, skeleton data is emitted
    ///   before the fetched data.
    /// - Returns:
    ///   A publisher that emits an ordered array of `MainSectionNotice` objects.
    ///   The section order always follows `NoticeCategory.allCases`.
    /// - Throws:
    ///   Publishes an error if any notice request fails.
    public func execute(isRefresh: Bool) -> AnyPublisher<[MainSectionNotice], any Error> {
        let publishers = NoticeCategory.allCases.map { category in
            repository.fetchNotices(for: category.rawValue, size: 3)
                .map { notices -> (NoticeCategory, [NoticeSnapshot]) in
                    (category, notices.map { self.createSnapshot(from: $0) })
                }
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
                        category: category,
                        items: notices.map { MainNotice(presentationType: .actual, noticeSnapshot: $0) }
                    )
                    sectionNotices[category] = sectionNotice
                }
                
                // Ensure order follows NoticeCategory.allCases
                return NoticeCategory.allCases.map { category in
                    sectionNotices[category, default: MainSectionNotice(header: "", category: category, items: [])]
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
                category: category,
                items: Notice.skeletonNotices().map {
                    MainNotice(presentationType: .skeleton, noticeSnapshot: createSnapshot(from: $0))
                }
            )
        }
    }
    
}

public extension Notice {
    static func skeletonNotices(count: Int = 3) -> [Self] {
        (0..<count).map { index in
            Notice(
                id: UUID().hashValue,
                title: "공지사항 제목이 들어갈 자리입니다. 로딩 중입니다.",
                contentUrl: "",
                isSummarizable: false,
                department: "학사운영팀",
                uploadDate: "2026.00.00",
                imageUrl: nil,
                category: NoticeCategory.generalNotice,
            )
        }
    }
}
