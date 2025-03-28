//
//  ReportRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine

protocol ReportRepository {
    func register(params: [String: Any]) -> AnyPublisher<Bool, any Error>
}
