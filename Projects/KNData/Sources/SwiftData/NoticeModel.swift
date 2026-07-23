//
//  NoticeModel.swift
//  KNData
//
//  Created by 이정훈 on 7/21/26.
//

import Foundation
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
    var contentUrl: URL?
    
    /// A Boolean value indicating whether the notice content can be summarized.
    var isSummarizable: Bool
    
    /// The department or organization that published the notice.
    var department: String
    
    /// The date string when the notice was uploaded.
    var uploadDate: String
    
    /// The optional image URL string associated with the notice.
    var imageUrl: String?
    
    /// The identifier of the topic associated with the notice.
    var topicId: Int
    
    /// Creates a notice model with the provided notice information.
    init(
        id: Int,
        title: String,
        contentUrl: URL? = nil,
        isSummarizable: Bool,
        department: String,
        uploadDate: String,
        imageUrl: String? = nil,
        topicId: Int
    ) {
        self.id = id
        self.title = title
        self.contentUrl = contentUrl
        self.isSummarizable = isSummarizable
        self.department = department
        self.uploadDate = uploadDate
        self.imageUrl = imageUrl
        self.topicId = topicId
    }
}
