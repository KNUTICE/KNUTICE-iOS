//
//  MainNotice.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/3/24.
//

import Foundation

struct MainNotice {
    enum PresentationType {
        case skeleton
        case actual
    }
    
    let presentationType: PresentationType
    let notice: Notice
}
