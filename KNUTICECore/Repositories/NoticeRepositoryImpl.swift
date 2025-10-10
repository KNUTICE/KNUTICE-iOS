//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Combine
import Foundation

public final class NoticeRepositoryImpl: NoticeRepository, NoticeCreatable {
    private let dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.standard.noticeURL
    
    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchNotices(
        for category: String? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> {
        guard let baseURL = baseURL, var components = URLComponents(string: baseURL) else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource."))
                .eraseToAnyPublisher()
        }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "size", value: String(size))
        ]
        
        if let category {
            queryItems.append(URLQueryItem(name: "topic", value: category))
        }
        
        if let keyword {
            queryItems.append(URLQueryItem(name: "keyword", value: keyword))
        }
        
        if let nttId {
            queryItems.append(URLQueryItem(name: "nttId", value: String(nttId)))
        }
        
        components.queryItems = queryItems
        
        guard let endpoint = components.url?.absoluteString else {
            return Fail(error: NetworkError.invalidURL(message: "Failed to build endpoint URL."))
                        .eraseToAnyPublisher()
        }
        
        return dataSource.request(
            endpoint,
            method: .get,
            decoding: NoticeResponseDTO.self
        )
        .map { [weak self] dto in
            dto.data?.compactMap { self?.createNotice($0) } ?? []
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchNotices(
        for category: String? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) async throws -> [Notice] {
        var fetchedNotices = [Notice]()
        let publisher = fetchNotices(for: category, keyword: keyword, after: nttId, size: size) as AnyPublisher<[Notice], any Error>
        
        for try await notices in publisher.values {
            fetchedNotices = notices
        }

        return fetchedNotices
    }
    
    @available(*, deprecated)
    public func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error> {        
        let publishers = nttIds.map { fetchNotice(by: $0) }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { notices in notices.compactMap { $0 } }
            .eraseToAnyPublisher()
    }
    
    public func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error> {
        guard let baseURL = baseURL else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource."))
                .eraseToAnyPublisher()
        }
        
        return dataSource.request(
            baseURL + "/\(nttId)",
            method: .get,
            decoding: SingleNoticeResponseDTO.self
        )
        .map { [weak self] dto in
            return dto.data.flatMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchNotice(by nttId: Int) async throws -> Notice? {
        var notice: Notice?
        let publisher = fetchNotice(by: nttId) as AnyPublisher<Notice?, any Error>
        
        for try await result in publisher.values {
            notice = result
        }
        
        return notice
    }
    
}
