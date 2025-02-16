//
//  NoticeCreatable.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import Foundation

protocol NoticeCreatable {
    func createNotice(_ dto: NoticeReponseDTO) -> [Notice]?
}

extension NoticeCreatable {
    func createNotice(_ dto: NoticeReponseDTO) -> [Notice]? {
        return dto.body?.map {
            return Notice(id: $0.nttID,
                          boardNumber: $0.contentNumber,
                          title: $0.title,
                          contentUrl: $0.contentURL,
                          department: $0.departmentName,
                          uploadDate: $0.registeredAt,
                          imageUrl: $0.contentImage,
                          noticeCategory: NoticeCategory(rawValue: $0.noticeName))
        }
    }
}
