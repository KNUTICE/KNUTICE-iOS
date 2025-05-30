//
//  NotificationSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

protocol NotificationSubscriptionRepository {
    func fetch() async -> Result<NotificationSubscription, Error>
    func update(params: [String: Any]) async throws
}
