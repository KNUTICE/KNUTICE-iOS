//
//  NoticeCreatable.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import Foundation

protocol NoticeCreatable {
    func createNotice(_ body: NoticeReponseBody) -> Notice
}

extension NoticeCreatable {    
    func createNotice(_ body: NoticeReponseBody) -> Notice {
        return Notice(
            id: body.nttID,
            title: body.title,
            contentUrl: body.contentURL,
            department: body.departmentName,
            uploadDate: body.registeredAt,
            imageUrl: body.contentImage,
            noticeCategory: NoticeCategory(rawValue: body.noticeName))
    }
}
