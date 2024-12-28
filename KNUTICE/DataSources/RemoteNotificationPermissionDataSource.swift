//
//  RemoteNotificationPermissionDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import Alamofire
import Combine

protocol RemoteNotificationPermissionDataSource {
    func sendUpdateRequest(to url: String, params: Parameters) -> AnyPublisher<NotificationPermissionUpdateDTO, any Error>
}

final class RemoteNotificationPermissionDataSourceImpl: RemoteNotificationPermissionDataSource {
    func sendUpdateRequest(to url: String, params: Parameters) -> AnyPublisher<NotificationPermissionUpdateDTO, any Error> {
        return AF.request(url,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
        .publishDecodable(type: NotificationPermissionUpdateDTO.self)
        .value()
        .mapError {
            $0 as Error
        }
        .eraseToAnyPublisher()
    }
}
