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
    
    let id: Int    //nttId
    let presentationType: PresentationType
    let title: String    //제목
    let contentUrl: String    //화면 전환 시 이동할 사이트 URL
    let department: String    //부서
    let uploadDate: String    //등록 날짜
}
