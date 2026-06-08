//
//  MainNotice.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/3/24.
//

import Foundation
import KNUtility

public struct MainNotice: Equatable, Sendable {
    public enum PresentationType: Sendable {
        case skeleton
        case actual
    }
    
    public let presentationType: PresentationType
    public let noticeSnapshot: NoticeSnapshot
    
    public init(presentationType: PresentationType, noticeSnapshot: NoticeSnapshot) {
        self.presentationType = presentationType
        self.noticeSnapshot = noticeSnapshot
    }
    
    public static func == (lhs: MainNotice, rhs: MainNotice) -> Bool {
        return lhs.noticeSnapshot == rhs.noticeSnapshot && lhs.presentationType == rhs.presentationType
    }
}

public struct MainSectionNotice: Equatable, Sendable {
    public let header: String
    public let category: any CategoryProtocol
    public let items: [MainNotice]
    
    public init(
        header: String,
        category: any CategoryProtocol,
        items: [MainNotice]
    ) {
        self.header = header
        self.category = category
        self.items = items
    }
    
    public static func == (lhs: MainSectionNotice, rhs: MainSectionNotice) -> Bool {
        return lhs.items == rhs.items
    }
}
