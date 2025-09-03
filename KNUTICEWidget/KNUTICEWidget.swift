//
//  KNUTICEWidget.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 8/5/25.
//

import WidgetKit
import SwiftUI
import KNUTICECore
import KNUTICEWidgetCore

struct KNUTICEWidget: Widget {
    let kind: String = "KNUTICEWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: NoticeWidgetConfigurationAppIntent.self, provider: Provider()) { entry in
            NoticeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("공지")
        .description("최신 공지를 한 눈에 확인하세요.")
    }
}

#Preview(as: .systemSmall) {
    KNUTICEWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: nil, notices: [Notice.generalNoticesSampleData.first!])
    SimpleEntry(date: .now, configuration: nil, notices: [Notice.academicNoticesSampleData.first!])
}
