//
//  Bookmark.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

struct Bookmark {
    let notice: Notice
    var details: String
    var alarmDate: Date?
}

#if DEBUG
extension Bookmark {
    static var sample: Bookmark {
        Bookmark(
            notice: Notice.generalNoticesSampleData.first!,
            details: "내용없음",
            alarmDate: Date()
        )
    }
}
#endif
