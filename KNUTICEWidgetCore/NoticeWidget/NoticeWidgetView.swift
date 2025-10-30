//
//  NoticeWidgetView.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 9/3/25.
//

import KNUTICECore
import WidgetKit
import SkeletonUI
import SwiftUI

public struct NoticeWidgetEntryView<T: SelectNoticeCategoryIntentInterface> : View {
    @Environment(\.widgetFamily) private var family: WidgetFamily
    private var entry: Provider<T>.Entry
    
    public init(entry: Provider<T>.Entry) {
        self.entry = entry
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                CategoryTitleView(title: entry.configuration?.category.rawValue as? String, isPlaceholder: entry.isPlaceholder)
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
            .font(.subheadline)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .skeleton(
                with: isPlaceholder,
                size: CGSize(width: 80, height: 10),
                shape: .rectangle
            )
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
        .skeleton(with: isPlaceholder, shape: .rectangle)
    }
    
}

public struct KNUTICEWidget<T: SelectNoticeCategoryIntentInterface>: Widget {
    public let kind: String
    
    public init() {
        self.kind = "KNUTICEWidget"
    }
    
    public init(kind: String) {
        self.kind = kind
    }
    
    public var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: T.self, provider: Provider()) { entry in
            NoticeWidgetEntryView<T>(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("공지")
        .description("최신 공지를 한 눈에 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
    
}
