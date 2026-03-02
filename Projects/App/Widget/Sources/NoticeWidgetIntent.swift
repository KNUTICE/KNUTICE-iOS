//
//  NoticeWidgetIntent.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/1/26.
//

import AppIntents
import KNUtility

struct NoticeWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "공지" }
    static var description: IntentDescription { "최신 공지를 한 눈에 확인하세요." }
    
    @Parameter(title: "공지 카테고리", default: .generalNotice)
    var category: WidgetNoticeCategory
}
