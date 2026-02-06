//
//  NoticeSummaryRepository.swift
//  KNNoticeSummary
//
//  Created by 이정훈 on 1/29/26.
//

import Foundation

protocol NoticeSummaryRepository: Actor {
    func fetch(for nttId: Int) async throws -> NoticeSummary
}
