//
//  Bookmark.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import Foundation

public struct Bookmark: Identifiable, Sendable {
    /// The unique identifier of the bookmark, matching the associated notice identifier.
    public var id: Int { notice.id }
    
    /// The notice associated with the bookmark.
    public let notice: Notice
    
    /// A user-written memo saved with the bookmark.
    public var memo: String
    
    /// The optional date when the bookmark alarm should be triggered.
    public var alarmDate: Date?
    
    /// Creates a bookmark with the provided notice, memo, and optional alarm date.
    public init(
        notice: Notice,
        memo: String,
        alarmDate: Date? = nil
    ) {
        self.notice = notice
        self.memo = memo
        self.alarmDate = alarmDate
    }
}

public extension Bookmark {
    /// Returns a bookmark with the provided department when the associated notice does not already have one.
    ///
    /// - Parameter department: The department to assign when the associated notice has no department.
    /// - Returns: A bookmark with the provided department, or the current bookmark when the notice already has one.
    func withDepartmentIfNeeded(_ department: String) -> Bookmark {
        guard notice.department == nil else { return self }

        return Bookmark(
            notice: Notice(
                id: notice.id,
                title: notice.title,
                contentURL: notice.contentURL,
                isSummarizable: notice.isSummarizable,
                department: department,
                uploadDate: notice.uploadDate,
                imageURL: notice.imageURL,
                topicId: notice.topicId
            ),
            memo: memo,
            alarmDate: alarmDate
        )
    }
}

#if DEBUG
public extension Bookmark {
    static var sample: Bookmark {
        Bookmark(
            notice: Notice.generalNoticesSample.first!,
            memo: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            alarmDate: Date()
        )
    }
}
#endif
