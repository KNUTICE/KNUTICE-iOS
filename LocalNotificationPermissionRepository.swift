//
//  LocalNotificationPermissionRepository.swift
//  
//
//  Created by 이정훈 on 2/11/25.
//


import Combine

protocol LocalNotificationPermissionRepository {
    func getNotificationPermissions() -> AnyPublisher<[String: Bool], any Error>
    func update(key: NotificationKind, value: Bool) -> AnyPublisher<Void, any Error>
}