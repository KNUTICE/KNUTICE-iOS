//
//  TopicRepositoryImpl.swift
//  KNData
//
//  Created by 이정훈 on 7/7/26.
//

import Factory
import Foundation
import KNDomain
import KNNetwork

/// A repository that retrieves topic information from the remote server.
public actor TopicRepositoryImpl: TopicRepository {
    
    @Injected(\.remoteDataSource) private var dataSource
    
    /// The base URL used to request topic data.
    private let baseURLV1: String? = Bundle.module.topicURLV1
    private let baseURLV2: String? = Bundle.module.topicURLV2
    
    public init() {}
    
    /// Fetches all topics of the specified type.
    ///
    /// - Parameter type: The type of topics to retrieve.
    /// - Returns: An array of categories corresponding to the specified topic type.
    /// - Throws: A `NetworkError` if the request cannot be completed or the URL is invalid.
    public func getAllTopics(for type: TopicType) async throws -> [any CategoryProtocol] {
        try Task.checkCancellation()

        let dto = try await request(
            baseURL: baseURLV1,
            path: "/types",
            queryItems: [
                .init(name: "type", value: type.rawValue)
            ]
        )

        switch type {
        case .notice:
            return dto.noticeCategories
        case .major:
            return dto.majorCategories
        case .meal:
            return dto.cafeteriaCategories
        }
    }
    
    /// Fetches the topic matching the specified identifier and type.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the topic.
    /// - Returns: An array containing the matching category, or an empty array if no match is found.
    /// - Throws: A `NetworkError` if the request cannot be completed or the URL is invalid.
    public func getTopics(id: Int) async throws -> [any CategoryProtocol] {
        try Task.checkCancellation()
        
        if 1...5 ~= id {
            return [id].compactMap { NoticeCategory(id: $0) }
        }
        
        if 900...999 ~= id {
            return [id].compactMap { CafeteriaCategory(id: $0) }
        }
        
        // 인메모리 캐시 확인
        if let cachedTopic = await TopicMemoryCache.shared.topic(for: id) {
            return [cachedTopic]
        }
        
        // 서버에서 topic 정보 가져오기
        let dto = try await request(
            baseURL: baseURLV2,
            path: "/types",
            queryItems: [
                URLQueryItem(name: "topicId", value: "\(id)")
            ]
        )

        let categories = dto.categories
        
        // 메모리에 캐싱
        if let category = categories.first {
            await TopicMemoryCache.shared.store(category, for: id)
        }
        
        return categories
    }
    
    /// Fetches topics matching the specified legacy topic string.
    ///
    /// - Parameter topic: The legacy string-based topic identifier.
    /// - Returns: An array of categories associated with the specified topic.
    /// - Throws: A `NetworkError` if the request cannot be completed or the request URL is invalid.
    public func getTopics(_ topic: String, type: TopicType) async throws -> [any CategoryProtocol] {
        try Task.checkCancellation()
        
        if let noticeCategory = NoticeCategory(rawValue: topic), type == .notice {
            return [noticeCategory]
        }
        
        if let cafeteriaCategory = CafeteriaCategory(rawValue: topic), type == .meal {
            return [cafeteriaCategory]
        }
        
        let dto = try await request(
            baseURL: baseURLV1,
            path: "/types",
            queryItems: [
                URLQueryItem(name: "type", value: type.rawValue),
                URLQueryItem(name: "topic", value: topic)
            ]
        )

        return dto.categories
    }
    
    /// Sends a topic request using the specified query parameters.
    ///
    /// - Parameter queryItems: The query parameters to include in the request URL.
    /// - Returns: The decoded topic response.
    /// - Throws: A `NetworkError` if the request URL is invalid or the request fails.
    private func request(
        baseURL: String?,
        path: String? = nil,
        queryItems: [URLQueryItem]
    ) async throws -> TopicResponseDTO {
        try Task.checkCancellation()

        guard let baseURL,
              var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'topicURL' in resource.")
        }

        if let path {
            components.path += path.hasPrefix("/") ? path : "/\(path)"
        }

        components.queryItems = queryItems

        guard let endpoint = components.url?.absoluteString else {
            throw NetworkError.invalidURL(message: "Failed to build endpoint URL.")
        }

        return try await dataSource.request(
            endpoint,
            method: .get,
            decoding: TopicResponseDTO.self,
            useFCMToken: true
        )
    }
}

extension TopicResponseDTO {
    
    /// The notice categories converted from the response.
    var noticeCategories: [NoticeCategory] {
        data?.compactMap { NoticeCategory(id: $0.topicId) } ?? []
    }

    /// The major categories converted from the response.
    var majorCategories: [MajorCategory] {
        data?.map {
            MajorCategory(
                id: $0.topicId,
                localizedDescription: $0.name,
                topic: $0.topic,
                college: $0.college
            )
        } ?? []
    }

    /// The cafeteria categories converted from the response.
    var cafeteriaCategories: [CafeteriaCategory] {
        data?.compactMap { CafeteriaCategory(id: $0.topicId) } ?? []
    }
    
    /// All categories converted from the response.
    ///
    /// Each item is mapped to the appropriate domain category type based on its identifier.
    var categories: [any CategoryProtocol] {
        data?.map { $0.category } ?? []
    }
}

extension TopicData {
    /// The domain category corresponding to this topic.
    ///
    /// The category type is determined from the topic identifier.
    var category: any CategoryProtocol {
        if let notice = NoticeCategory(id: topicId) {
            return notice
        }

        if let cafeteria = CafeteriaCategory(id: topicId) {
            return cafeteria
        }

        return MajorCategory(
            id: topicId,
            localizedDescription: name,
            topic: topic,
            college: college
        )
    }

}
