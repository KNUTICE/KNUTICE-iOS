//
//  NotificationRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine

protocol NotificationRepository {
    func getNotificationPermissions() -> AnyPublisher<[String: Bool], any Error>
    func update(key: NotificationKind, value: Bool) -> AnyPublisher<Void, any Error>
}
