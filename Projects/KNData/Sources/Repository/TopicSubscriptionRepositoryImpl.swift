//
//  TopicSubscriptionRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Factory
import Foundation
import KNDomain
import KNNetwork

public actor TopicSubscriptionRepositoryImpl: TopicSubscriptionRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.module.topicURLV1
    
    public init() {}
    
    /// Fetches the identifiers of the topics the current user is subscribed to for the specified topic type.
    ///
    /// This method performs the following steps:
    /// 1. Checks for task cancellation before proceeding.
    /// 2. Builds the request URL with the specified `TopicType`.
    /// 3. Sends a `GET` request with the FCM token automatically injected by `NetworkInterceptor`.
    /// 4. Decodes the response and returns the subscribed topic identifiers.
    ///
    /// - Note: Subscriptions for `.meal` are not currently supported and always return an empty array.
    ///
    /// - Parameter type: The type of topics to retrieve subscriptions for.
    ///
    /// - Returns: An array of subscribed topic identifiers.
    ///
    /// - Throws:
    ///   - `CancellationError` if the task is cancelled before the request is sent.
    ///   - `NetworkError.invalidURL` if `topicSubscriptionURL` is missing or invalid.
    ///   - Any networking or decoding error propagated from `RemoteDataSource`.
    public func fetch(for type: TopicType) async throws -> [Int] {
        try Task.checkCancellation()
        
        guard let baseURL else {
            throw NetworkError.invalidURL(message: "The Topic subscription API URL is missing or invalid.")
        }
        
        let endpoint = baseURL + "?type=\(type.rawValue)"
        let dto = try await dataSource.request(
            endpoint,
            method: .get,
            decoding: TopicSubscriptionResponseDTO.self,
            useFCMToken: true
        )
        
        return dto.data.subscribedTopicIds
    }
    
    /// Subscribes the current user to the specified topic.
    ///
    /// - Parameters:
    ///   - type: The type of the topic to subscribe to.
    ///   - id: The identifier of the topic to subscribe to.
    ///
    /// - Throws:
    ///   - `CancellationError` if the task is cancelled before the request is sent.
    ///   - `NetworkError.invalidURL` if `topicSubscriptionURL` is missing or invalid.
    ///   - Any networking error propagated from `RemoteDataSource`.
    public func subscribe(of type: TopicType, topicID id: Int) async throws {
        try Task.checkCancellation()
        try await updateSubscription(of: type, topicID: id, enabled: true)
    }
    
    /// Unsubscribes the current user from the specified topic.
    ///
    /// - Parameters:
    ///   - type: The type of the topic to unsubscribe from.
    ///   - id: The identifier of the topic to unsubscribe from.
    ///
    /// - Throws:
    ///   - `CancellationError` if the task is cancelled before the request is sent.
    ///   - `NetworkError.invalidURL` if `topicSubscriptionURL` is missing or invalid.
    ///   - Any networking error propagated from `RemoteDataSource`.
    public func unsubscribe(of type: TopicType, topicID id: Int) async throws {
        try Task.checkCancellation()
        try await updateSubscription(of: type, topicID: id, enabled: false)
    }
    
    /// Updates the subscription state of a topic on the server.
    ///
    /// - Parameters:
    ///   - type: The type of the topic.
    ///   - topicID: The identifier of the topic.
    ///   - enabled: A Boolean value indicating whether the topic should be subscribed to.
    ///     Pass `true` to subscribe or `false` to unsubscribe.
    ///
    /// - Throws:
    ///   - `CancellationError` if the task is cancelled before the request is sent.
    ///   - `NetworkError.invalidURL` if `topicSubscriptionURL` is missing or invalid.
    ///   - Any networking error propagated from `RemoteDataSource`.
    private func updateSubscription(
        of type: TopicType,
        topicID: Int,
        enabled: Bool
    ) async throws {
        try Task.checkCancellation()

        guard let baseURL else {
            throw NetworkError.invalidURL(
                message: "The Topic subscription API URL is missing or invalid."
            )
        }

        let endpoint = "\(baseURL)?type=\(type.rawValue)"
        let requestBody: [String: any Sendable] = [
            "topicId": topicID,
            "enabled": enabled
        ]

        try await dataSource.request(
            endpoint,
            method: .patch,
            parameters: requestBody,
            decoding: PostResponseDTO.self,
            useFCMToken: true
        )
    }
    
}

