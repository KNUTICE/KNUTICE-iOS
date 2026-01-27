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

extension Bundle {
    static var topicModule: Bundle {
        Bundle(for: TopicSubscriptionRepositoryImpl.BundleFinder.self)
    }
}

public actor TopicSubscriptionRepositoryImpl: TopicSubscriptionRepository {
    class BundleFinder {}
    
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.topicModule.topicSubscriptionURL
    
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

