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
    
    /// Updates the subscription status of a specific topic.
    ///
    /// - Parameters:
    ///   - type: The category type of the topic.
    ///   - topic: The specific category to update (must conform to `CategoryProtocol`).
    ///   - isEnabled: A boolean indicating whether to subscribe (`true`) or unsubscribe (`false`).
    /// - Throws: An error if the update request fails on the server side.
    func update(of type: TopicType, topic: any CategoryProtocol, isEnabled: Bool) async throws
}
