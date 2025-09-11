//
//  PostResponseDTO.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

// MARK: - PostResponseDTO
public struct PostResponseDTO: Decodable, Sendable {
    public let success: Bool
    public let code: Int
    public let message: String?
    public let data: Bool
}
