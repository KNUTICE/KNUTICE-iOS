//
//  NoticeModel.swift
//  KNData
//
//  Created by 이정훈 on 7/21/26.
//

import Foundation
import KNDomain
import SwiftData

/// A SwiftData model that stores a notice item for local persistence.
@available(iOS 17.0, *)
@available(macCatalyst 17.0, *)
@Model
final class NoticeModel {
    /// The unique identifier of the notice.
    @Attribute(.unique)
    var id: Int
    
    /// The title displayed for the notice.
    var title: String
    
    /// The optional URL for the notice content page.
    var contentURL: URL?
    
    /// A Boolean value indicating whether the notice content can be summarized.
    var isSummarizable: Bool
    
    /// The optional department or organization that published the notice.
    var department: String?
    
    /// The date string when the notice was uploaded.
    var uploadDate: String
    
    /// The optional image URL string associated with the notice.
    var imageURL: String?
    
    /// The identifier of the topic associated with the notice.
    var topicId: Int
    
    /// Creates a notice model with the provided notice information.
    init(
        id: Int,
        title: String,
        contentURL: URL? = nil,
        isSummarizable: Bool,
        department: String? = nil,
        uploadDate: String,
        imageURL: String? = nil,
        topicId: Int
    ) {
        self.id = id
        self.title = title
        self.contentURL = contentURL
        self.isSummarizable = isSummarizable
        self.department = department
        self.uploadDate = uploadDate
        self.imageURL = imageURL
        self.topicId = topicId
    }
    
    convenience init(notice: Notice) {
        self.init(
            id: notice.id,
            title: notice.title,
            contentURL: notice.contentURL,
            isSummarizable: notice.isSummarizable,
            department: notice.department,
            uploadDate: notice.uploadDate,
            imageURL: notice.imageURL,
            topicId: notice.topicId
        )
    }
}
