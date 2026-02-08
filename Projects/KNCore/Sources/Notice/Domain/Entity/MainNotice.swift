//
//  MainNotice.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/3/24.
//

import Foundation

public struct MainNotice: Equatable, Sendable {
    public enum PresentationType: Sendable {
        case skeleton
        case actual
    }
    
    public let presentationType: PresentationType
    public let notice: Notice
    
    public init(presentationType: PresentationType, notice: Notice) {
        self.presentationType = presentationType
        self.notice = notice
    }
    
    public static func == (lhs: MainNotice, rhs: MainNotice) -> Bool {
        return lhs.notice.id == rhs.notice.id
    }
}

public struct MainSectionNotice: Equatable, Sendable {
    public let header: String
    public let items: [MainNotice]
    
    public init(header: String, items: [MainNotice]) {
        self.header = header
        self.items = items
    }
}
