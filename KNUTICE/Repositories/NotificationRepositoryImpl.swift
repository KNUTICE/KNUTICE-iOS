//
//  NotificationRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine

final class NotificationRepositoryImpl: NotificationRepository {
    private let dataSource: NotificationPermissionDataSource
    
    init(dataSource: NotificationPermissionDataSource) {
        self.dataSource = dataSource
    }
    
    func getNotificationPermissions() -> AnyPublisher<[String: Bool], any Error> {
        return dataSource.readData()
    }
    
    func update(key: NotificationKind, value: Bool) -> AnyPublisher<Void, any Error> {
        return dataSource.updateData(key: key, value: value)
    }
}