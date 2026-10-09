//
//  BookmarkModel.swift
//  KNData
//
//  Created by 이정훈 on 7/9/26.
//

import Foundation
import KNDomain
import SwiftData

/// A SwiftData model that stores a bookmarked notice and its user-defined metadata.
@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
@Model
final class BookmarkModel {
    /// The unique identifier of the bookmark, matching the associated notice identifier.
    @Attribute(.unique)
    var id: Int
    
    /// The NoticeModel associated with this BookmarkModel.
    @Relationship(deleteRule: .cascade)
    var notice: NoticeModel
    
    /// The user-written memo for the bookmarked notice.
    var memo: String
    
    /// The optional date when the user wants to receive an alarm for this bookmark.
    var alarmDate: Date?
    
    /// The date when the bookmark was created.
    var createdAt: Date
    
    /// The date when the bookmark was last updated.
    var updatedAt: Date
    
    /// Creates a bookmark model with the provided notice and user metadata.
    init(
        notice: NoticeModel,
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
extension BookmarkModel: @unchecked Sendable {}
