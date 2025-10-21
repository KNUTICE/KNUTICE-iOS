//
//  KNUTICEWidgetCore.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 9/2/25.
//

import KNUTICECore
import WidgetKit

public struct Provider<T: SelectNoticeCategoryIntentInterface>: AppIntentTimelineProvider {
    public init() {}
    
    /// Provides a placeholder entry for the widget display.
    ///
    /// This method is called when the widget is in a loading state or shown
    /// in the widget gallery. It supplies temporary mock data to represent
    /// how the widget will look once real data is available.
    ///
    /// - Parameter context: The widget rendering context that includes the current widget family.
    /// - Returns: A `SimpleEntry` containing mock notice data appropriate to the widget size.
    ///
    /// The number of mock notices varies by widget family:
    /// - `.systemSmall`: 1 item
    /// - `.systemMedium`: 3 items
    /// - `.systemLarge`: 5 items
    public func placeholder(in context: Context) -> SimpleEntry {
        let noticeCount: Int = {
            switch context.family {
            case .systemLarge:
                return 5
            case .systemMedium:
                return 3
            default:
                return 1
            }
        }()
        
        return SimpleEntry(
            date: Date(),
            configuration: nil,
            notices: Notice.mock(count: noticeCount),
            isPlaceholder: true
        )
    }
    
    /// Provides a snapshot entry for the widget, typically used in the widget gallery
    /// or when the system needs a quick preview.
    ///
    /// - Parameters:
    ///   - configuration: The current App Intent configuration selected by the user.
    ///   - context: The environment context in which the widget is running.
    /// - Returns: A `SimpleEntry` containing sample notice data.
    public func snapshot(for configuration: T, in context: Context) async -> SimpleEntry {
        let noticeCount: Int = {
            switch context.family {
            case .systemLarge:
                return 5
            case .systemMedium:
                return 3
            default:
                return 1
            }
        }()
        let notices = await fetchData(limit: noticeCount, category: configuration.category.toNoticeCategory)
        
        return SimpleEntry(date: Date(), configuration: configuration, notices: notices, isPlaceholder: false)
    }
    
    /// Generates a timeline of entries for the widget.
    ///
    /// This method is responsible for providing a series of timeline entries
    /// that determine what the widget displays over time. It fetches the latest
    /// notice data and creates entries at fixed intervals, ensuring that
    /// the widget content stays up to date.
    ///
    /// - Parameters:
    ///   - configuration: The current App Intent configuration that specifies the selected notice category.
    ///   - context: The widget rendering context, which includes the current widget family.
    /// - Returns: A `Timeline` containing multiple `SimpleEntry` instances scheduled for future updates.
    ///
    /// The number of notices per entry varies by widget size:
    /// - `.systemSmall`: 1 item
    /// - `.systemMedium`: 3 items
    /// - `.systemLarge`: 5 items
    ///
    /// The timeline refreshes automatically **15 minutes after the last entry**.
    ///
    /// - Note: If the task is cancelled or no entries are available, the method
    ///   returns an empty timeline with a `.never` policy.
    public func timeline(for configuration: T, in context: Context) async -> Timeline<SimpleEntry> {
        guard !Task.isCancelled else {
            return Timeline(entries: [], policy: .never)
        }
        
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let notices = await fetchData(limit: 5, category: configuration.category.toNoticeCategory)

        let maxCount = {
            switch context.family {
            case .systemMedium:
                return 3
            case .systemLarge:
                return 5
            default:
                return 1
            }
        }()
        
        for i in 0..<(notices.count - maxCount + 1) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: i * 3, to: currentDate)!
            let subNotices = Array(notices[i..<i + maxCount])
            entries.append(SimpleEntry(date: entryDate, configuration: configuration, notices: subNotices, isPlaceholder: false))
        }
        
        // 마지막 엔트리의 date + 15분 후에 새로 로드
        if let lastDate = entries.last?.date,
           let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: lastDate) {
            return Timeline(entries: entries, policy: .after(refreshDate))
        }
        
        // entries가 비었을 경우 대비
        return Timeline(entries: entries, policy: .never)
    }
    
    private func fetchData(limit count: Int, category: NoticeCategory) async -> [Notice] {
        return await NoticeManager.shared.fetchNotices(limit: count, category: category)
    }
}

public struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: (any SelectNoticeCategoryIntentInterface)?
    public let notices: [Notice]
    public let isPlaceholder: Bool
    
    public init(
        date: Date,
        configuration: (any SelectNoticeCategoryIntentInterface)?,
        notices: [Notice],
        isPlaceholder: Bool
    ) {
        self.date = date
        self.configuration = configuration
        self.notices = notices
        self.isPlaceholder = isPlaceholder
    }
}

fileprivate extension Notice {
    static func mock(count: Int) -> [Self] {
        (1...count).map { index in
            Notice(
                id: index,
                title: "placeholder",
                contentUrl: "",
                department: "",
                uploadDate: "",
                imageUrl: nil
            )
        }
    }
}
