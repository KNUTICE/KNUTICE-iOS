//
//  LocalNotificationPermissionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Combine

protocol LocalNotificationPermissionRepository {
    func getNotificationPermissions() -> AnyPublisher<[String: Bool], any Error>
    func update(key: NotificationKind, value: Bool) -> AnyPublisher<Void, any Error>
}
