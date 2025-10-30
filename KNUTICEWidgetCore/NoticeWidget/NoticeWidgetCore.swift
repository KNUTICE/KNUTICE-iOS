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
    
    /// Determines the number of notices to display based on the widget family (size).
    /// - Parameter context: The current widget context provided by WidgetKit.
    /// - Returns: The number of notices to show in the widget depending on its size.
    private func getContentCount(in context: Context) -> Int {
        switch context.family {
        case .systemLarge:
            return 4
        case .systemMedium:
            return 2
        default:
            return 1
        }
    }
    
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
    /// - `.systemMedium`: 2 items
    /// - `.systemLarge`: 4 items
    public func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(
            date: Date(),
            configuration: nil,
            notices: Notice.mock(count: getContentCount(in: context)),
            isPlaceholder: true
        )
    }
    
    /// Provides a snapshot of the widget's content for preview purposes.
    /// This is typically used to display the widget in the widget gallery or during a quick refresh.
    /// - Parameters:
    ///   - configuration: The user-selected widget configuration (e.g., category).
    ///   - context: The current widget context provided by WidgetKit.
    /// - Returns: A `SimpleEntry` representing the current state of the widget.
    public func snapshot(for configuration: T, in context: Context) async -> SimpleEntry {
        guard !Task.isCancelled else {
            return SimpleEntry(date: Date(), configuration: configuration, notices: [], isPlaceholder: false)
        }
        
        let notices = await NoticeManager.shared.fetchNotices(limit: getContentCount(in: context), category: configuration.category.toNoticeCategory)
        
        return SimpleEntry(date: Date(), configuration: configuration, notices: notices, isPlaceholder: false)
    }
    
    /// Generates a timeline for the widget based on the provided configuration.
    /// - Parameters:
    ///   - configuration: The user-selected widget configuration (category, etc.).
    ///   - context: The current widget context provided by WidgetKit.
    /// - Returns: A `Timeline` containing a single `SimpleEntry` and a refresh policy.
    public func timeline(for configuration: T, in context: Context) async -> Timeline<SimpleEntry> {
        guard !Task.isCancelled else {
            return Timeline(entries: [], policy: .never)
        }
        
        let notices = await NoticeManager.shared.fetchNotices(limit: getContentCount(in: context), category: configuration.category.toNoticeCategory)
        let entries: [SimpleEntry] = [
            SimpleEntry(
                date: Date(),
                configuration: configuration,
                notices: notices,
                isPlaceholder: false
            )
        ]
        
        guard let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) else {
            return Timeline(entries: entries, policy: .never)
        }
        
        return Timeline(entries: entries, policy: .after(refreshDate))
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
