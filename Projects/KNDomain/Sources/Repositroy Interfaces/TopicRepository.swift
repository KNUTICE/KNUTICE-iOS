//
//  TopicRepository.swift
//  KNDomain
//
//  Created by 이정훈 on 7/6/26.
//

import Foundation

public protocol TopicRepository: Actor {
    func getAllTopics(for type: TopicType) async throws  -> [any CategoryProtocol]
    func getTopics(id: Int) async throws -> [any CategoryProtocol]
    func getTopics(_ topic: String, type: TopicType) async throws -> [any CategoryProtocol]
}
