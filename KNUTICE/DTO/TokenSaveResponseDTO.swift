//
//  TokenSaveResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import Foundation

// MARK: - TokenSaveResponseDTO
struct TokenSaveResponseDTO: Decodable {
    let result: RequestResult
    let body: Bool?
}
