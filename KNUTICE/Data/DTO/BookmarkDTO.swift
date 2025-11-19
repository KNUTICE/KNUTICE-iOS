//
//  BookmarkDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Foundation
import KNUTICECore

struct BookmarkDTO: Sendable {
    let noticeData: NoticeData
    let memo: String?
    let alarmDate: Date?
    
    init(
        from notice: Notice,
        memo: String?,
        alarmDate: Date?
    ) {
        self.noticeData = notice.noticeData
        self.memo = memo
        self.alarmDate = alarmDate
    }
    
    init(
        noticeData: NoticeData,
        memo: String?,
        alarmData: Date?
    ) {
        self.noticeData = noticeData
        self.memo = memo
        self.alarmDate = alarmData
    }
}

fileprivate extension Notice {
    var noticeData: NoticeData {
        NoticeData(
            nttID: id,
            title: title,
            contentURL: contentUrl,
            contentImageURL: imageUrl,
            department: department,
            registrationDate: uploadDate,
            topic: noticeCategory?.rawValue ?? ""
        )
    }
}
