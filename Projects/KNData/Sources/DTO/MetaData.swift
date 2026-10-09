//
//  MetaData.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/26/25.
//

import Foundation

// MARK: - MetaData
struct MetaData: Decodable, Sendable {
    let success: Bool
    let code: Int
    let message: String?
}
