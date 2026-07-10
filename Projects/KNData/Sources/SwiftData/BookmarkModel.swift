//
//  BookmarkModel.swift
//  KNData
//
//  Created by 이정훈 on 7/9/26.
//

import Foundation
import KNDomain
import SwiftData

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
@Model
final class BookmarkModel {
    @Attribute(.unique)
    var id: Int
    var notice: Notice
    var memo: String
    var alarmDate: Date?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        notice: Notice,
        memo: String,
        alarmDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = notice.id
        self.notice = notice
        self.memo = memo
        self.alarmDate = alarmDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
extension BookmarkModel {
    var asEntity: Bookmark {
        Bookmark(
            notice: notice,
            memo: memo,
            alarmDate: alarmDate
        )
    }
}
