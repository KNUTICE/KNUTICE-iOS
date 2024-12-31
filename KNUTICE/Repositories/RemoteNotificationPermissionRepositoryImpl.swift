//
//  NotificationRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Foundation

final class RemoteNotificationPermissionRepositoryImpl<T: RemoteDataSource>: RemoteNotificationPermissionRepository {
    private let dataSource: T
    
    init(dataSource: T) {
        self.dataSource = dataSource
    }
    
    func update(params: [String: Any]) -> AnyPublisher<Bool, any Error> {
        let url = Bundle.main.notificationPermissionURL
        
        return dataSource.sendPostRequest(to: url, params: params, resultType: NotificationPermissionUpdateDTO.self)
            .map {
                return $0.result.resultCode == 200 ? true : false
            }
            .eraseToAnyPublisher()
    }
}
