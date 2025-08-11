//
//  KNUTICEWidget.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 8/5/25.
//

import WidgetKit
import SwiftUI
import KNUTICECore

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), notices: [])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), notices: [])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        print("timeline(for:in:)")
        
        guard !Task.isCancelled else {
            return Timeline(entries: [], policy: .never)
        }
        
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let notices = await fetchData(limit: 5)

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
            entries.append(SimpleEntry(date: entryDate, notices: subNotices))
        }
        
        // 마지막 엔트리의 date + 1분 후에 새로 로드
        if let lastDate = entries.last?.date,
           let refreshDate = Calendar.current.date(byAdding: .second, value: 10, to: lastDate) {
            return Timeline(entries: entries, policy: .after(refreshDate))
        }
        
        // entries가 비었을 경우 대비
        return Timeline(entries: entries, policy: .never)
    }
    
    private func fetchData(limit count: Int) async -> [Notice] {
        return await NoticeManager.shared.fetchNotices(limit: count)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let notices: [Notice]
}

struct KNUTICEWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("일반소식")
                .font(.headline)
            
            ForEach(entry.notices, id: \.id) { notice in
                Text(notice.title)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .widgetURL(URL(string: notice.contentUrl))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct KNUTICEWidget: Widget {
    let kind: String = "KNUTICEWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            KNUTICEWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemSmall) {
    KNUTICEWidget()
} timeline: {
    SimpleEntry(date: .now, notices: [Notice.generalNoticesSampleData.first!])
    SimpleEntry(date: .now, notices: [Notice.academicNoticesSampleData.first!])
}
