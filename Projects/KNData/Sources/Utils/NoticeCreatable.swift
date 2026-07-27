//
//  NoticeCreatable.swift
//  KNDomain
//
//  Created by 이정훈 on 5/9/26.
//

import Foundation
import KNDomain

protocol NoticeCreatable {
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "Use createNotice(_ item: NoticeItem) instead.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "Use createNotice(_ item: NoticeItem) instead.")
    func createNotice(_ data: NoticeData) -> Notice

    @available(iOS 17.0, *)
    @available(macCatalyst 17.0, *)
    func createNotice(_ item: NoticeItem) -> Notice
}

extension NoticeCreatable {
    @available(iOS 17.0, *)
    @available(macCatalyst 17.0, *)
    func createNotice(_ item: NoticeItem) -> Notice {
        return Notice(
            id: item.nttID,
            title: item.title,
            contentURL: URL(string: item.contentURL),
            isSummarizable: item.isContentSummary,
            department: item.department,
            uploadDate: item.registrationDate,
            imageURL: item.contentImageURL,
            topicId: item.topicId
        )
    }

    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "Use createNotice(_ item: NoticeItem) instead.")
    @available(macCatalyst, introduced: 15.0, deprecated: 17.0, message: "Use createNotice(_ item: NoticeItem) instead.")
    func createNotice(_ data: NoticeData) -> Notice {
        return Notice(
            id: data.nttID,
            title: data.title,
            contentURL: URL(string: data.contentURL),
            isSummarizable: data.isContentSummary,
            department: data.department,
            uploadDate: data.registrationDate,
            imageURL: data.contentImageURL,
            topicId: Int(data.topic) ?? NoticeCategory.id(fromRawValue: data.topic) ?? 0
        )
    }
}
