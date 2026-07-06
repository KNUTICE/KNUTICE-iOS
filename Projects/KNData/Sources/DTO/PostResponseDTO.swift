//
//  PostResponseDTO.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

// MARK: - PostResponseDTO
struct PostResponseDTO: Decodable, Sendable {
    let metaData: MetaData
    let data: Bool
}
