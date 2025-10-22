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
        VStack(alignment: .leading, spacing: 20) {
            Group {
                if let title = entry.configuration?.category.rawValue as? String {
                    Text(title)
                        .font(.headline)
                } else {
                    Text("")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .skeleton(with: entry.isPlaceholder, size: CGSize(width: 80, height: 10), shape: .rectangle)
            
            ForEach(entry.notices, id: \.id) { notice in
                Group {
                    if let url = URL(string: "widget://notice?nttId=\(notice.id)") {
                        Link(destination: url) {
                            Text(notice.title)
                        }
                    } else {
                        // URL 생성 실패 시 fallback
                        Text(notice.title)
                    }
                }
                .font(family == .systemMedium ? .footnote : .subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(family != .systemSmall ? 1 : nil)
                .skeleton(with: entry.isPlaceholder, shape: .rectangle)
                .padding([.top, .bottom], family == .systemLarge ? 10 : 0)
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

//#Preview {
//    KNUTICEWidget<SelectNoticeCategoryIntent>()
//}
