//
//  TokenSaveResponseDTO.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import Foundation

// MARK: - TokenSaveResponseDTO
struct TokenSaveResponseDTO: Codable {
    let result: RequestResult
    let body: TokenSaveResponseBody
}

// MARK: - TokenSaveResponseBody
struct TokenSaveResponseBody: Codable {
    let message: String
}
