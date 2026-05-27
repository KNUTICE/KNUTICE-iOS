//
//  ReportRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation

public protocol ReportRepository: Actor {
    func register(params: [String: any Sendable]) async throws
}
