//
//  PostResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

//MARK: - ReportResponseDTO
public struct PostResponseDTO: Decodable {
    public let result: RequestResult
    public let body: Bool?
}
