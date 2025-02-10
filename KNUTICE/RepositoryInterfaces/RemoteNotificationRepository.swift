//
//  RemoteNotificationRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine

protocol RemoteNotificationRepository {    
    func update(params: [String: Any]) -> AnyPublisher<Bool, any Error>
}
