//
//  RequestResult.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/14/24.
//

import Foundation

// MARK: - RequestResult
struct RequestResult: Codable {
    let resultCode: Int
    let resultMessage, resultDescription: String
}
