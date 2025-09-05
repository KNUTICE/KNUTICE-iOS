//
//  PostResponseDTO.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

//MARK: - ReportResponseDTO
public struct PostResponseDTO: Decodable, Sendable {
    public let result: RequestResult
    public let body: Bool?
}
