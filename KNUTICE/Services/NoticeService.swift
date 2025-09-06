//
//  NoticeServie.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/5/25.
//

import Factory
import Foundation
import KNUTICECore

protocol NoticeService: Actor {
    /// Fetches the top three notices for each category.
    ///
    /// - Returns: An array of `MainSectionNotice` sorted by `NoticeCategory.allCases`.
    /// - Throws: An error if fetching notices fails.
    func fetchTopThreeNotices() async throws -> [MainSectionNotice]
    
    /// Returns mock notices for all categories.
    ///
    /// This method generates placeholder `MainSectionNotice` objects
    /// for every `NoticeCategory`. Each section contains a fixed number
    /// of `Notice.mockNotices`, wrapped as `MainNotice` with the
    /// `.skeleton` presentation type.
    ///
    /// - Returns: An array of `MainSectionNotice` containing skeleton data.
    func fetchMockNotices() -> [MainSectionNotice]
}

actor NoticeServiceImpl: NoticeService {
    @Injected(\.noticeRepository) private var repository: NoticeRepository
    
    func fetchTopThreeNotices() async throws -> [MainSectionNotice] {
        var sectionNotices = [NoticeCategory : MainSectionNotice]()
        
        // Run multiple fetch requests concurrently using a task group
        try await withThrowingTaskGroup(of: (NoticeCategory, [Notice]).self) { group in
            for category in NoticeCategory.allCases {
                group.addTask {
                    try Task.checkCancellation()
                    
                    let notices = try await self.repository.fetchNotices(for: category, size: 3)
                    return (category, notices)
                }
            }
            
            for try await (category, notices) in group {
                try Task.checkCancellation()
                
                let sectionNotice = MainSectionNotice(
                    header: category.localizedDescription,
                    items: notices.map { MainNotice(presentationType: .actual, notice: $0) }
                )
                
                sectionNotices[category] = sectionNotice
            }
        }
        
        // Ensure the order of results follows `NoticeCategory.allCases`.
        return NoticeCategory.allCases.map { category in
            sectionNotices[category, default: MainSectionNotice(header: "", items: [])]
        }
    }
    
    func fetchMockNotices() -> [MainSectionNotice] {
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
