//
//  Bookmark.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

struct Bookmark {
    let notice: Notice
    var memo: String
    var alarmDate: Date?
}

#if DEBUG
extension Bookmark {
    static var sample: Bookmark {
        Bookmark(
            notice: Notice.generalNoticesSampleData.first!,
            memo: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            alarmDate: Date()
        )
    }
}
#endif
