//
//  NotificationRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine

protocol RemoteNotificationPermissionRepository {    
    func update(params: [String: Any]) -> AnyPublisher<Bool, any Error>
}
