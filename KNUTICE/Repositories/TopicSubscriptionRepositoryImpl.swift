//
//  TopicSubscriptionRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import Foundation

final class TopicSubscriptionRepositoryImpl: TopicSubscriptionRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func fetch() async -> Result<NotificationSubscription, Error> {
        do {
            let endPoint = Bundle.main.notificationPermissionURL
            let dto = try await dataSource.request(
                endPoint,
                method: .get,
                decoding: NotificationSubscriptionDTO.self,
                isInterceptable: true
            )
            
            let entity = NotificationSubscription(
                generalNotice: dto.body.generalNewsTopic,
                scholarshipNotice: dto.body.scholarshipNewsTopic,
                eventNotice: dto.body.eventNewsTopic,
                academicNotice: dto.body.academicNewsTopic,
                employmentNotice: dto.body.employmentNewsTopic
            )
            
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }
    
    func update(params: [String: Any]) async throws {
        let endPoint = Bundle.main.notificationPermissionURL
        try await dataSource.request(
            endPoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
    }
}
