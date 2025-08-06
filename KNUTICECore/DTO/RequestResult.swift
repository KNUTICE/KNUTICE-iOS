//
//  RequestResult.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/14/24.
//

import Foundation

// MARK: - RequestResult
public struct RequestResult: Codable {
    public let resultCode: Int
    public let resultMessage, resultDescription: String
}
