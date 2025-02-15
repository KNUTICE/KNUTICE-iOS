//
//  PostResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

//MARK: - ReportResponseDTO
struct PostResponseDTO: Decodable {
    let result: RequestResult
    let body: Bool?
}
