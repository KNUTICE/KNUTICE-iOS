//
//  MainNoticeDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import Foundation

// MARK: - MainNoticeDTO
struct MainNoticeDTO: Decodable {
    let statusCode: Int
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let generalNewsTopThreeTitle, scholarshipNewsTopThreeTitle, eventNewsTopThreeTitle, academicNewsTopThreeTitle: [NewsTopThreeTitle]
}

// MARK: - NewsTopThreeTitle
struct NewsTopThreeTitle: Decodable {
    let registrationDate: String
    let nttId: Int
    let title: String
    let contentURL: String
    let departName: String
}
