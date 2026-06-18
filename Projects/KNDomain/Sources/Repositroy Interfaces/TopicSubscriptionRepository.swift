//
//  TopicSubscriptionRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import KNUtility

public protocol TopicSubscriptionRepository: Actor {
    /// Retrieves a list of currently subscribed topics for a specific category type.
    ///
    /// - Parameter topicType: The classification of topics to fetch (e.g., notice, major, or meal).
    /// - Returns: An array of `TopicSubscriptionKey` representing the active subscriptions.
    /// - Throws: An error if the network request fails or data mapping is unsuccessful.
    func fetch(for topicType: TopicType) async throws -> [TopicSubscriptionKey]
    
    /// Subscribes the current user to the specified topic.
    ///
    /// - Parameters:
    ///   - type: The category type that the topic belongs to.
    ///   - topic: The topic to subscribe to.
    /// - Throws: An error if the subscription request fails.
    func subscribe(of type: TopicType, topic: any CategoryProtocol) async throws
    
    /// Unsubscribes the current user from the specified topic.
    ///
    /// - Parameters:
    ///   - type: The category type that the topic belongs to.
    ///   - topic: The topic to unsubscribe from.
    /// - Throws: An error if the unsubscription request fails.
    func unsubscribe(of type: TopicType, topic: any CategoryProtocol) async throws
}
