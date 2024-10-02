//
//  ReportResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

//MARK: - ReportResponseDTO
struct ReportResponseDTO: Decodable {
    let result: RequestResult
    let body: ReportResponseBody
}

// MARK: - ReportResponseBody
struct ReportResponseBody: Decodable {
    let message: String
}
