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
import KNUtility

public actor TopicSubscriptionRepositoryImpl: TopicSubscriptionRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.module.topicSubscriptionURL
    
    public init() {}
    
    /// Fetches the list of subscribed topics for the given topic type from the server.
    ///
    /// This method performs the following steps:
    /// 1. Checks for task cancellation before proceeding.
    /// 2. Constructs the query URL by appending the `TopicType` as a query parameter.
    /// 3. Sends a `GET` request with the FCM token injected into the header by `NetworkInterceptor`.
    /// 4. Maps raw string values from the response DTO into typed `TopicSubscriptionKey` cases,
    ///    discarding any unrecognized values via `compactMap`.
    ///
    /// - Note: `.meal` type subscriptions are not yet supported and always return an empty list.
    ///
    /// - Parameter type: The topic category type to retrieve subscriptions for (e.g. `.notice`, `.major`).
    ///
    /// - Returns: A list of valid `TopicSubscriptionKey` objects corresponding to the subscribed topics.
    ///
    /// - Throws:
    ///   - `CancellationError` if the enclosing `Task` was cancelled before the request was dispatched.
    ///   - `NetworkError.invalidURL` if `topicSubscriptionURL` is absent or malformed in the module bundle.
    ///   - Any networking or decoding error propagated from `RemoteDataSource`.
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
            useFCMToken: true
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
                if value == CafeteriaCategory.studentCafeteria.rawValue {
                    return .studentCafeteria
                } else if value == CafeteriaCategory.staffCafeteria.rawValue {
                    return .staffCafeteria
                } else {
                    return nil
                }
            }
        }
    }
    
    /// Subscribes the current user to the specified topic.
    public func subscribe(of type: TopicType, topic: any CategoryProtocol) async throws {
        try Task.checkCancellation()
        try await updateSubscription(of: type, topic: topic, enabled: true)
    }
    
    /// Unsubscribes the current user from the specified topic.
    public func unsubscribe(of type: TopicType, topic: any CategoryProtocol) async throws {
        try Task.checkCancellation()
        try await updateSubscription(of: type, topic: topic, enabled: false)
    }
    
    /// Updates the subscription state of the specified topic on the server.
    private func updateSubscription(
        of type: TopicType,
        topic: any CategoryProtocol,
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
            "topic": topic.topic,
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

