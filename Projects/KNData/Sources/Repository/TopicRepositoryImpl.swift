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
    private let baseURL: String? = Bundle.module.topicURL
    
    public init() {}
    
    /// Fetches all topics of the specified type.
    ///
    /// - Parameter type: The type of topics to retrieve.
    /// - Returns: An array of categories corresponding to the specified topic type.
    /// - Throws: A `NetworkError` if the request cannot be completed or the URL is invalid.
    public func getAllTopics(for type: TopicType) async throws -> [any CategoryProtocol] {

        let dto = try await request(
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
        // TODO: 학교 공지와 식당 카테고리는 네트워크 요청 없이 즉시 반환
        let dto = try await request(
            queryItems: [
                URLQueryItem(name: "topicId", value: "\(id)")
            ]
        )

        return dto.categories
    }
    
    /// Fetches topics matching the specified legacy topic string.
    ///
    /// - Parameter topic: The legacy string-based topic identifier.
    /// - Returns: An array of categories associated with the specified topic.
    /// - Throws: A `NetworkError` if the request cannot be completed or the request URL is invalid.
    public func getTopics(_ topic: String) async throws -> [any CategoryProtocol] {
        // TODO: 학교 공지와 식당 카테고리는 네트워크 요청 없이 즉시 반환
        let dto = try await request(
            queryItems: [
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
        queryItems: [URLQueryItem]
    ) async throws -> TopicResponseDTO {

        guard let baseURL = baseURL,
              var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'topicURL' in resource.")
        }

        components.queryItems = queryItems

        guard let endpoint = components.url?.absoluteString else {
            throw NetworkError.invalidURL(message: "Failed to build endpoint URL.")
        }

        return try await dataSource.request(
            endpoint,
            method: .get,
            decoding: TopicResponseDTO.self
        )
    }
}

extension TopicResponseDTO {
    
    /// The notice categories converted from the response.
    var noticeCategories: [NoticeCategory] {
        data.map { NoticeCategory(id: $0.topicId) ?? .generalNotice }
    }

    /// The major categories converted from the response.
    var majorCategories: [MajorCategory] {
        data.map {
            MajorCategory(
                id: $0.topicId,
                localizedDescription: $0.name,
                topic: $0.topic,
                college: $0.college
            )
        }
    }

    /// The cafeteria categories converted from the response.
    var cafeteriaCategories: [CafeteriaCategory] {
        data.map { CafeteriaCategory(id: $0.topicId) ?? .studentCafeteria }
    }
    
    /// All categories converted from the response.
    ///
    /// Each item is mapped to the appropriate domain category type based on its identifier.
    var categories: [any CategoryProtocol] {
        data.map { $0.category }
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
