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
        return Notice(
            id: data.nttID,
            title: data.title,
            contentUrl: data.contentURL,
            isSummarizable: data.isContentSummary,
            department: data.department,
            uploadDate: data.registrationDate,
            imageUrl: data.contentImageURL,
            topic: data.topic
        )
    }
}
