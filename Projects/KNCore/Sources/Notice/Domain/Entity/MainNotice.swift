//
//  MainNotice.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/3/24.
//

import Foundation

public struct MainNotice {
    public enum PresentationType {
        case skeleton
        case actual
    }
    
    public let presentationType: PresentationType
    public let notice: Notice
}

public struct MainSectionNotice {
    public let header: String
    public let items: [MainNotice]
}
