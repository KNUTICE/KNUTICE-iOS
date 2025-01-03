//
//  LocalNotificationPermissionRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Combine

final class LocalNotificationPermissionRepositoryImpl<T: LocalNotificationPermissionDataSource>: LocalNotificationPermissionRepository {
    private let dataSource: T
    
    init(dataSource: T) {
        self.dataSource = dataSource
    }
    
    func getNotificationPermissions() -> AnyPublisher<[String: Bool], any Error> {
        return dataSource.readData()
    }
    
    func update(key: NotificationKind, value: Bool) -> AnyPublisher<Void, any Error> {
        return dataSource.updateData(key: key, value: value)
    }
}
