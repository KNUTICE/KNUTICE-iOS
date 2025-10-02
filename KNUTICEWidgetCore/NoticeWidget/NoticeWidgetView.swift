//
//  NoticeWidgetView.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 9/3/25.
//

import KNUTICECore
import WidgetKit
import SwiftUI

public struct NoticeWidgetEntryView<T: SelectNoticeCategoryIntentInterface> : View {
    @Environment(\.widgetFamily) private var family: WidgetFamily
    private var entry: Provider<T>.Entry
    
    public init(entry: Provider<T>.Entry) {
        self.entry = entry
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let title = entry.configuration?.category.rawValue as? String {
                Text(title)
                    .font(.headline)
            }
            
            ForEach(entry.notices, id: \.id) { notice in
                if let url = URL(string: "widget://notice?nttId=\(notice.id)") {
                    Link(destination: url) {
                        Text(notice.title)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                    }
                } else {
                    // URL 생성 실패 시 fallback
                    Text(notice.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
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
