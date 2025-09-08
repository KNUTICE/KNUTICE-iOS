//
//  TipRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Foundation

protocol TipRepository: Actor {
    func fetchTips() async -> Result<[Tip]?, any Error>
}
