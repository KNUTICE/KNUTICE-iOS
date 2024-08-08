//
//  TokenSaveResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import Foundation

struct TokenSaveResponseDTO: Decodable {
    let statusCode: Int
    let message: String
    let data: String?
}
