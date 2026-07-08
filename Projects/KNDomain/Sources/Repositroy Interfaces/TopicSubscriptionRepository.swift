//
//  TopicSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import KNUtility

public protocol TopicSubscriptionRepository: Actor {
    /// Retrieves the identifiers of the topics currently subscribed to for the specified topic type.
    ///
    /// - Parameter topicType: The type of topics to retrieve (for example, notice, major, or meal).
    /// - Returns: An array of subscribed topic identifiers.
    /// - Throws: An error if the request fails or the response cannot be processed.
    func fetch(for topicType: TopicType) async throws -> [Int]
    
    /// Subscribes the current user to the specified topic.
    ///
    /// - Parameters:
    ///   - type: The type of the topic to subscribe to.
    ///   - topicID: The identifier of the topic to subscribe to.
    /// - Throws: An error if the subscription request fails.
    func subscribe(of type: TopicType, topicID: Int) async throws
    
    /// Unsubscribes the current user from the specified topic.
    ///
    /// - Parameters:
    ///   - type: The type of the topic to unsubscribe from.
    ///   - topicID: The identifier of the topic to unsubscribe from.
    /// - Throws: An error if the unsubscription request fails.
    func unsubscribe(of type: TopicType, topicID: Int) async throws
}
