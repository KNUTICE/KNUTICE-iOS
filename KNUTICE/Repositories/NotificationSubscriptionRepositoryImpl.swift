//
//  NotificationSubscriptionRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import Foundation

final class NotificationSubscriptionRepositoryImpl: NotificationSubscriptionRepository {
    @Injected(\.remoteDataSource) private var remoteDataSource: RemoteDataSource
    @Injected(\.localNotificationDataSource) private var localDatasource: LocalNotificationSubscriptionDataSource
    
    func createLocalSubscription() -> AnyPublisher<Void, any Error> {
        return localDatasource.createData()
    }
    
    func updateToServer(params: [String: Any]) -> AnyPublisher<Bool, any Error> {
        let url = Bundle.main.notificationPermissionURL
        
        return remoteDataSource.sendPostRequest(to: url, params: params, resultType: PostResponseDTO.self)
            .flatMap { dto -> AnyPublisher<Bool, any Error> in
                guard dto.result.resultCode == 200 else {
                    return Fail(error: RemoteServerError.invalidResponse(message: dto.result.resultMessage))
                        .eraseToAnyPublisher()
                }
                
                return Just(true)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateToLocal(key: NoticeCategory, value: Bool) -> AnyPublisher<Void, any Error> {
        return localDatasource.updateData(key: key, value: value)
    }
    
    func fetchNotificationPermissions() -> AnyPublisher<[String: Bool], any Error> {
        return localDatasource.readData()
    }
}
