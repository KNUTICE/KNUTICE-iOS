//
//  ReadingRoomWidgetIntent.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 4/2/26.
//

import AppIntents

struct ReadingRoomWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "열람실" }
    static var description: IntentDescription { "열람실 실시간 현황을 확인하세요." }
}
