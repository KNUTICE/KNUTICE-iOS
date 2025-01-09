//
//  Bookmark.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

struct Bookmark: Identifiable {
    let id: UUID
    var description: String
    var alarmDate: Date?
    var noticeKind: NoticeKind?
    let notice: Notice
}

#if DEBUG
extension Bookmark {
    static var sample: Bookmark {
        Bookmark(
            id: UUID(),
            description: "내용없음",
            alarmDate: Date(),
            noticeKind: .generalNotice,
            notice: Notice.generalNoticesSampleData.first!
        )
    }
}
#endif
