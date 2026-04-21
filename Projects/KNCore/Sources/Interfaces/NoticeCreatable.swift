//
//  NoticeCreatable.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import Foundation
import KNUtility

public protocol NoticeCreatable {
    func createNotice(_ body: NoticeData) -> Notice
}

public extension NoticeCreatable {
    func createNotice(_ data: NoticeData) -> Notice {
        let extractedCategory: any CategoryProtocol
        
        if let category = NoticeCategory(rawValue: data.topic) {
            extractedCategory = category
        } else if let category = MajorCategory(rawValue: data.topic) {
            extractedCategory = category
        } else {
            extractedCategory = NoticeCategory.generalNotice
        }
        
        return Notice(
            id: data.nttID,
            title: data.title,
            contentUrl: data.contentURL,
            isSummarizable: data.isContentSummary,
            department: data.department,
            uploadDate: data.registrationDate,
            imageUrl: data.contentImageURL,
            category: extractedCategory
        )
    }
}
