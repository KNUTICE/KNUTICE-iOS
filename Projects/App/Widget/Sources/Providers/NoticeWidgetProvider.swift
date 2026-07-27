//
//  NoticeWidgetProvider.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 3/2/26.
//

import Factory
import Foundation
import KNDomain
import KNUtility
import WidgetKit

struct NoticeWidgetProvider: AppIntentTimelineProvider {
    private let fetchNoticeSnapshotsUseCase: FetchNoticeSnapshotsUseCase = Container.shared.fetchNoticeSnapshotsUseCase()
    
    /// Returns placeholder entry displayed while the widget is loading
    /// - Note: Uses mock data with redacted styling instead of real data
    func placeholder(in context: Context) -> NoticeEntry {
        return NoticeEntry(
            date: Date(),
            category: .generalNotice,
            notices: Notice.mock(count: getContentCount(for: context.family)),
            isPlaceholder: true
        )
    }
    
    /// Returns a snapshot entry for widget gallery previews
    /// - Note: Attempts to fetch real data; falls back to an empty array on failure
    func snapshot(for configuration: NoticeWidgetIntent, in context: Context) async -> NoticeEntry {
        let notices = try? await fetchNoticeSnapshotsUseCase.execute(
            category: NoticeCategory.generalNotice,
            size: getContentCount(for: context.family)
        ).map { $0.notice }
        
        return NoticeEntry(
            date: Date(),
            category: .generalNotice,
            notices: notices ?? [],
            isPlaceholder: false
        )
    }
    
    /// Builds and returns the widget timeline
    /// - Note: Refreshes every 2 hours returns an empty timeline if the task is cancelled
    func timeline(for configuration: NoticeWidgetIntent, in context: Context) async -> Timeline<NoticeEntry> {
        let category = configuration.category
        let notices = try? await fetchNoticeSnapshotsUseCase.execute(
            category: category.toNoticeCategory,
            size: getContentCount(for: context.family)
        ).map { $0.notice }
        let entries: [NoticeEntry] = [
            NoticeEntry(
                date: Date(),
                category: category,
                notices: notices ?? [],
                isPlaceholder: false
            )
        ]
        
        guard let refreshDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) else {
            return Timeline(entries: entries, policy: .never)
        }
        
        return Timeline(entries: entries, policy: .after(refreshDate))
    }
    
    /// Returns the number of notices to display based on widget size
    /// - Parameter family: The widget family (size)
    /// - Returns: 4 for large, 2 for medium, 1 for small
    private func getContentCount(for family: WidgetFamily) -> Int {
        switch family {
        case .systemLarge:
            return 4
        case .systemMedium:
            return 2
        default:
            return 1
        }
    }
    
}

// MARK: - Timeline Entry

/// Data model representing a single widget timeline entry
struct NoticeEntry: TimelineEntry {
    let date: Date
    let category: WidgetNoticeCategory
    let notices: [Notice]
    let isPlaceholder: Bool
}

// MARK: - Mock Data

fileprivate extension Notice {
    /// Generates mock notices for placeholder display
    /// - Parameter count: Number of mock notices to generate
    static func mock(count: Int) -> [Self] {
        (1...count).map { index in
            Notice(
                id: index,
                title: "여기에 공지사항의 제목이 표시됩니다. 스켈레톤 뷰 렌더링을 위한 텍스트입니다.",
                contentURL: nil,
                isSummarizable: false,
                department: "소프트웨어학과",
                uploadDate: "2024-04-09",
                imageURL: nil,
                topicId: NoticeCategory.generalNotice.id,
            )
        }
    }
}
