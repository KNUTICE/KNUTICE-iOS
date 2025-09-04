//
//  NoticeCategory.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 8/22/25.
//

import AppIntents
import KNUTICECore

public enum NoticeCategoryIntent: String, AppEnum {
    case generalNotice = "일반소식"
    case academicNotice = "학사공지"
    case scholarshipNotice = "장학안내"
    case eventNotice = "행사안내"
    case employmentNotice = "취업안내"
    
    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "공지 카테고리"
        
    public static var caseDisplayRepresentations: [NoticeCategoryIntent: DisplayRepresentation] {
        [
            .generalNotice: "일반소식",
            .academicNotice: "학사공지",
            .scholarshipNotice: "장학안내",
            .eventNotice: "행사안내",
            .employmentNotice: "취업안내"
        ]
    }
    
    public var toNoticeCategory: NoticeCategory {
        switch self {
        case .generalNotice:
            return .generalNotice
        case .academicNotice:
            return .academicNotice
        case .scholarshipNotice:
            return .scholarshipNotice
        case .eventNotice:
            return .eventNotice
        case .employmentNotice:
            return .employmentNotice
        }
    }
}
