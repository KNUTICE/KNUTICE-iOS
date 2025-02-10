//
//  NotificationRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import Foundation

final class RemoteNotificationRepositoryImpl: RemoteNotificationRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func update(params: [String: Any]) -> AnyPublisher<Bool, any Error> {
        let url = Bundle.main.notificationPermissionURL
        
        return dataSource.sendPostRequest(to: url, params: params, resultType: NotificationPermissionUpdateDTO.self)
            .map {
                return $0.result.resultCode == 200 ? true : false
            }
            .eraseToAnyPublisher()
    }
}
