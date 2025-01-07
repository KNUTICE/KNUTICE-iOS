//
//  Bookmark.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

struct Bookmark: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var isAlarmOn: Bool
    var isCompleted: Bool
    var alarmTime: Date?
    var noticeKind: NoticeKind?
}

#if DEBUG
extension Bookmark {
    static var sample: Bookmark {
        Bookmark(
            id: UUID(),
            title: "2025년 1학기 장학금 신청",
            content: "내용없음",
            date: Date(),
            isAlarmOn: false,
            isCompleted: false,
            alarmTime: nil,
            noticeKind: .generalNotice
        )
    }
}
#endif
