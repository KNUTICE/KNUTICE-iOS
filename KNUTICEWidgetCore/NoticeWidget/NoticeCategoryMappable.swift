//
//  NoticeCategoryMappable.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 9/4/25.
//

import Foundation
import KNUTICECore

public protocol NoticeCategoryMappable {
    var toNoticeCategory: NoticeCategory { get }
}

public extension NoticeCategoryMappable where Self: RawRepresentable, Self.RawValue == String {
    var toNoticeCategory: NoticeCategory {
        return NoticeCategory(rawValue: self.rawValue) ?? .generalNotice
    }
}
