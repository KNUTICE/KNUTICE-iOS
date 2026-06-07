//
//  NoticeCreatable.swift
//  KNDomain
//
//  Created by 이정훈 on 5/9/26.
//

import Foundation
import KNDomain

protocol NoticeCreatable {
    func createNotice(_ body: NoticeData) -> Notice
}

extension NoticeCreatable {
    func createNotice(_ data: NoticeData) -> Notice {
        let category: any CategoryProtocol =
        (NoticeCategory(rawValue: data.topic) as (any CategoryProtocol)?)
        ?? (MajorCategory(rawValue: data.topic) as (any CategoryProtocol)?)
        ?? NoticeCategory.generalNotice
        
        return Notice(
            id: data.nttID,
            title: data.title,
            contentUrl: data.contentURL,
            isSummarizable: data.isContentSummary,
            department: data.department,
            uploadDate: data.registrationDate,
            imageUrl: data.contentImageURL,
            category: category
        )
    }
}
