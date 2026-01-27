//
//  TopicSubscriptionRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Factory
import Foundation
import KNNetwork
import KNUtility

public actor TopicSubscriptionRepositoryImpl: TopicSubscriptionRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.module.topicSubscriptionURL
    
    /// Fetches and maps subscribed topics from the server.
    ///
    /// This method performs the following:
    /// 1. Constructs the query URL with the specified `TopicType`.
    /// 2. Executes a GET request with interception for authentication.
    /// 3. Validates and maps raw string values from the DTO into specific category enums.
    ///
    /// - Note: Currently, `.meal` type subscriptions are not supported and will return an empty list.
    ///
    /// - Parameter type: The type of topics to retrieve.
    /// - Returns: A filtered list of valid `TopicSubscriptionKey` objects.
    public func fetch(for type: TopicType) async throws -> [TopicSubscriptionKey] {
        try Task.checkCancellation()
        
        guard let baseURL else {
            throw NetworkError.invalidURL(message: "The Topic subscription API URL is missing or invalid.")
        }
        
        let endpoint = baseURL + "?type=\(type.rawValue)"
        let dto = try await dataSource.request(
            endpoint,
            method: .get,
            decoding: TopicSubscriptionResponseDTO.self,
            isInterceptable: true
        )
        
        return dto.data.subscribedTopics.compactMap { value -> TopicSubscriptionKey? in
            switch type {
            case .notice:
                // Map raw string to NoticeCategory, then wrap in TopicSubscriptionKey.notice
                guard let category = NoticeCategory(rawValue: value) else { return nil }
                return .notice(category)
            case .major:
                // Map raw string to MajorCategory, then wrap in TopicSubscriptionKey.major
                guard let category = MajorCategory(rawValue: value) else { return nil }
                return .major(category)
            case .meal:
                // TODO: Enable subscription for `.meal` in the future
                return nil
            }
        }
    }
    
    /// Updates the server-side subscription state for a specific topic category.
    ///
    /// Sends a PATCH request containing the topic identifier and the desired enabled state.
    ///
    /// - Parameters:
    ///   - type: The category type (Notice, Major, etc.).
    ///   - topic: The specific category instance to modify.
    ///   - isEnabled: The new subscription state.
    public func update(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws {
        try Task.checkCancellation()
        
        guard let baseURL else {
            throw NetworkError.invalidURL(message: "The Topic subscription API URL is missing or invalid.")
        }
        
        let endpoint = baseURL + "?type=\(type.rawValue)"
        let requestBody = [
            "topic": topic.rawValue,
            "enabled": isEnabled
        ] as [String: any Sendable]
        
        try await dataSource.request(
            endpoint,
            method: .patch,
            parameters: requestBody,
            decoding: PostResponseDTO.self,
            isInterceptable: true
        )
    }
}

