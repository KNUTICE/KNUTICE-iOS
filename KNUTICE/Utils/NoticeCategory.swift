//
//  NoticeCategory.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/15/25.
//

import Foundation

enum NoticeCategory: String, Codable {
    case generalNotice = "GENERAL_NEWS"
    case academicNotice = "ACADEMIC_NEWS"
    case scholarshipNotice = "SCHOLARSHIP_NEWS"
    case eventNotice = "EVENT_NEWS"
    case employmentNotice = "EMPLOYMENT_NEWS"
    
    var localizedDescription: String {
        switch self {
        case .generalNotice:
            return "일반소식"
        case .academicNotice:
            return "학사공지"
        case .scholarshipNotice:
            return "장학공지"
        case .eventNotice:
            return "행사안내"
        case .employmentNotice:
            return "취업안내"
        }
    }
}
