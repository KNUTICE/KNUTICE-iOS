//
//  MetaData.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/26/25.
//

import Foundation

// MARK: - MetaData
public struct MetaData: Decodable, Sendable {
    public let success: Bool
    public let code: Int
    public let message: String?
}
