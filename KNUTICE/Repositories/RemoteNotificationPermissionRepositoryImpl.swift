//
//  NotificationRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Foundation

final class RemoteNotificationPermissionRepositoryImpl<T: RemoteNotificationPermissionDataSource>: RemoteNotificationPermissionRepository {
    private let dataSource: T
    
    init(dataSource: T) {
        self.dataSource = dataSource
    }
    
    func update(params: [String: Any]) -> AnyPublisher<Bool, any Error> {
        let url = Bundle.main.notificationPermissionURL
        
        return dataSource.sendUpdateRequest(to: url, params: params)
            .map {
                return $0.result.resultCode == 200 ? true : false
            }
            .eraseToAnyPublisher()
    }
}
