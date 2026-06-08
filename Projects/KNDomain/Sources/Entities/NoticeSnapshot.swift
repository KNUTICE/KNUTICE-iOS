//
//  NoticeSnapShot.swift
//  KNDomain
//
//  Created by 이정훈 on 6/6/26.
//

import Foundation

public struct NoticeSnapshot: Sendable {
    public let notice: Notice
    public let isNew: Bool
    
    public init(notice: Notice, isNew: Bool) {
        self.notice = notice
        self.isNew = isNew
    }
}

extension NoticeSnapshot: Identifiable {
    public var id: Int {
        notice.id
    }
}

extension NoticeSnapshot: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.notice == rhs.notice && lhs.isNew == rhs.isNew
    }
}
