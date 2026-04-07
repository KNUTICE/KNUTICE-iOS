//
//  RefreshReadingRoomIntent.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 4/7/26.
//

import AppIntents
import WidgetKit

struct RefreshWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "새로고침"
    static var description = IntentDescription("위젯의 데이터를 즉시 새로고침합니다.")
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
