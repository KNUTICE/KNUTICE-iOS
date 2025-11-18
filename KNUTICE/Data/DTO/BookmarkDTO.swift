//
//  BookmarkDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Foundation

struct BookmarkDTO : @unchecked Sendable {
    let notice: NoticeEntity?
    let details: String?
    let alarmDate: Date?
}
