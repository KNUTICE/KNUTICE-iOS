//
//  NoticeWidgetConfigurationAppIntent.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 8/5/25.
//

import AppIntents
import WidgetKit

public protocol SelectNoticeCategoryIntentInterface: WidgetConfigurationIntent {
    var category: NoticeCategoryIntent { get }
}

#if DEBUG
public struct TestNoticeWidgetConfigurationIntent: SelectNoticeCategoryIntentInterface {
    public static var title: LocalizedStringResource { "공지" }
    public static var description: IntentDescription { "최신 공지를 한 눈에 확인하세요." }

    @Parameter(title: "공지 카테고리", default: .generalNotice)
    public var category: NoticeCategoryIntent
    
    public init() {}
}
#endif
