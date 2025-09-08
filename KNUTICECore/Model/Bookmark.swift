//
//  Bookmark.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation
import RxDataSources

public struct Bookmark: Sendable {
    public let notice: Notice
    public var memo: String
    public var alarmDate: Date?
    
    public init(notice: Notice, memo: String, alarmDate: Date? = nil) {
        self.notice = notice
        self.memo = memo
        self.alarmDate = alarmDate
    }
}

extension Bookmark: IdentifiableType, Equatable {
    public typealias Identity = Int
    
    public var identity: Int {
        return notice.id
    }
    
    public static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.identity == rhs.identity
    }
}

#if DEBUG
public extension Bookmark {
    static var sample: Bookmark {
        Bookmark(
            notice: Notice.generalNoticesSampleData.first!,
            memo: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            alarmDate: Date()
        )
    }
}
#endif

public struct BookmarkUpdate: Sendable {
    public let bookmark: Bookmark
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(bookmark: Bookmark, createdAt: Date, updatedAt: Date) {
        self.bookmark = bookmark
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
