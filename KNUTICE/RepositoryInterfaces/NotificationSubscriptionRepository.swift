//
//  NotificationSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine

protocol NotificationSubscriptionRepository {    
    func updateToServer(params: [String: Any]) -> AnyPublisher<Bool, any Error>
    func updateToLocal(key: NoticeCategory, value: Bool) -> AnyPublisher<Void, any Error>
    func getNotificationPermissions() -> AnyPublisher<[String: Bool], any Error>
}
