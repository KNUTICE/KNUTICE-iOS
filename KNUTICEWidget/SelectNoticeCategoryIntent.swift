//
//  SelectNoticeCategoryIntent.swift
//  KNUTICEWidget-devExtension
//
//  Created by 이정훈 on 9/4/25.
//

import AppIntents
import Foundation
import KNUTICECore
import KNUTICEWidgetCore

enum NoticeCategoryIntent: String, AppEnum, NoticeCategoryMappable {
    case generalNotice = "일반소식"
    case academicNotice = "학사공지"
    case scholarshipNotice = "장학안내"
    case eventNotice = "행사안내"
    case employmentNotice = "취업안내"
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "공지 카테고리"
        
    static var caseDisplayRepresentations: [NoticeCategoryIntent: DisplayRepresentation] {
        [
            .generalNotice: "일반소식",
            .academicNotice: "학사공지",
            .scholarshipNotice: "장학안내",
            .eventNotice: "행사안내",
            .employmentNotice: "취업안내"
        ]
    }
}

struct SelectNoticeCategoryIntent: SelectNoticeCategoryIntentInterface {
    static var title: LocalizedStringResource { "공지" }
    static var description: IntentDescription { "최신 공지를 한 눈에 확인하세요." }

    @Parameter(title: "공지 카테고리", default: .generalNotice)
    var category: NoticeCategoryIntent
}
