//
//  NoticeCreatable.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import Foundation

public protocol NoticeCreatable {
    func createNotice(_ body: NoticeData) -> Notice
}

public extension NoticeCreatable {
    func createNotice(_ data: NoticeData) -> Notice {
        return Notice(
            id: data.nttID,
            title: data.title,
            contentUrl: data.contentURL,
            department: data.department,
            uploadDate: data.registrationDate,
            imageUrl: data.contentImageURL,
            noticeCategory: NoticeCategory(rawValue: data.topic),
            majorCategory: MajorCategory(rawValue: data.topic)
        )
    }
}
