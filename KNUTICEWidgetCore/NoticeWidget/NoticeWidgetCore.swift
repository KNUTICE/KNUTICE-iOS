//
//  KNUTICEWidgetCore.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 9/2/25.
//

import AppIntents
import WidgetKit
import KNUTICECore

public struct Provider: AppIntentTimelineProvider {
    public typealias Entry = SimpleEntry
    public typealias Intent = NoticeWidgetConfigurationAppIntent
    
    public init() {}
    
    public func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: nil, notices: [])
    }

    public func snapshot(for configuration: NoticeWidgetConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: nil, notices: [])
    }
    
    public func timeline(for configuration: NoticeWidgetConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        print("timeline(for:in:)")
        
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
            let entryDate = Calendar.current.date(byAdding: .second, value: i * 10, to: currentDate)!
            let subNotices = Array(notices[i..<i + maxCount])
            entries.append(SimpleEntry(date: entryDate, configuration: configuration, notices: subNotices))
        }
        
        // 마지막 엔트리의 date + 1분 후에 새로 로드
        if let lastDate = entries.last?.date,
           let refreshDate = Calendar.current.date(byAdding: .second, value: 10, to: lastDate) {
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
    public let configuration: NoticeWidgetConfigurationAppIntent?
    public let notices: [Notice]
    
    public init(date: Date, configuration: NoticeWidgetConfigurationAppIntent?, notices: [Notice]) {
        self.date = date
        self.configuration = configuration
        self.notices = notices
    }
}
