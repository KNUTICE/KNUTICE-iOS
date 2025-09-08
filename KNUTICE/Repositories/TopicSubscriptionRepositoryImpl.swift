//
//  TopicSubscriptionRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import Foundation
import KNUTICECore

actor TopicSubscriptionRepositoryImpl: TopicSubscriptionRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func fetch() async -> Result<NotificationSubscription, Error> {
        guard !Task.isCancelled else {
            return .failure(CancellationError())
        }
        
        guard let endPoint = Bundle.main.notificationPermissionURL else {
            return .failure(NetworkError.invalidURL(message: "The Topic subscription API URL is missing or invalid."))
        }
        
        do {
            
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
    
    func update(params: [String: any Sendable]) async throws {
        try Task.checkCancellation()
        
        guard let endPoint = Bundle.main.notificationPermissionURL else {
            throw NetworkError.invalidURL(message: "The Topic subscription API URL is missing or invalid.")
        }
        
        try await dataSource.request(
            endPoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
    }
}
