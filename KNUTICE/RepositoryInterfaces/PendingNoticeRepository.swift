//
//  PendingNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/16/25.
//

import Foundation

protocol PendingNoticeRepository {
    func fetchAll() async throws -> [Int]
    func delete(id: Int) async throws
}
