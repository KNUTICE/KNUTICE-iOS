//
//  NoticeWidgetEntryView.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/1/26.
//

import KNCore
import KNDomain
import WidgetKit
import SwiftUI

// MARK: - Widget Entry View
struct KNUTICEWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: NoticeWidgetProvider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                CategoryTitleView(title: entry.category.rawValue, isPlaceholder: entry.isPlaceholder)
                    .padding(.bottom, 10)
                
                ForEach(entry.notices, id: \.id) { notice in
                    VStack(alignment: .leading, spacing: 0) {
                        NoticeRowView(
                            notice: notice,
                            family: family,
                            isPlaceholder: entry.isPlaceholder
                        )
                        Spacer(minLength: 0)
                    }
                    .frame(height: geometry.size.height / CGFloat(entry.notices.count) - 5)
                }
            }
        }
    }
}

// MARK: - Category Title View
fileprivate struct CategoryTitleView: View {
    let title: String?
    let isPlaceholder: Bool
    
    var body: some View {
        Text(title ?? "")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .redacted(reason: isPlaceholder ? .placeholder : [])
    }
    
}

// MARK: - Notice Row View
fileprivate struct NoticeRowView: View {
    let notice: Notice
    let family: WidgetFamily
    let isPlaceholder: Bool
    
    var body: some View {
        Group {
            if let url = URL(string: "widget://notice?nttId=\(notice.id)") {
                Link(destination: url) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(notice.title)
                        HStack(spacing: 5) {
                            if family != .systemSmall {
                                Text("[" + notice.department + "]")
                            }
                            
                            Text(notice.uploadDate)
                        }
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                    }
                }
            } else {
                Text(notice.title)
            }
        }
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(family == .systemSmall ? 4 : 1)
        .padding(.vertical, family == .systemLarge ? 10 : 0)
        .redacted(reason: isPlaceholder ? .placeholder : [])
    }
    
}

// MARK: - Widget Configuration
struct NoticeWidget: Widget {
    private let kind: String = "NoticeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: NoticeWidgetIntent.self, provider: NoticeWidgetProvider()) { entry in
            KNUTICEWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("공지 사항")
        .description("최신 공지 사항을 확인합니다.")
    }
}

// MARK: - Preview

#if DEBUG
#Preview(as: .systemSmall) {
    NoticeWidget()
} timeline: {
    NoticeEntry(date: .now, category: .generalNotice, notices: [Notice.generalNoticesSample.first!], isPlaceholder: false)
    NoticeEntry(date: .now, category: .generalNotice, notices: [Notice.academicNoticesSample.first!], isPlaceholder: false)
}
#endif
