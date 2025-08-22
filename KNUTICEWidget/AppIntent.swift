//
//  AppIntent.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 8/5/25.
//

import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "공지" }
    static var description: IntentDescription { "최신 공지를 한 눈에 확인하세요." }

    // An example configurable parameter.
    @Parameter(title: "공지 카테고리", default: .generalNotice)
    var category: NoticeCategoryIntent
}
