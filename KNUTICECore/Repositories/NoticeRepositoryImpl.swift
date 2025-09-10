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
    
    public func fetchNotices<T>(
        for category: T,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> where T: RawRepresentable, T.RawValue == String {
        guard let baseURL = baseURL else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource."))
                .eraseToAnyPublisher()
        }
        
        var endpoint = baseURL + "?topic=\(category.rawValue)"
        endpoint += "&size=\(size)"
        
        if let nttId {
            endpoint += "&nttId=\(nttId)"
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
    
    public func fetchNotices<T>(
        for category: T,
        after nttId: Int? = nil,
        size: Int = 20
    ) async throws -> [Notice] where T: RawRepresentable, T.RawValue == String {
        var fetchedNotices = [Notice]()
        for try await notices in fetchNotices(for: category, after: nttId, size: size).values {
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
        try Task.checkCancellation()
        
        guard let baseURL = baseURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource.")
        }
        
        let dto =  try await dataSource.request(
            baseURL + "/\(nttId)",
            method: .get,
            decoding: SingleNoticeResponseDTO.self
        )
        
        guard let data = dto.data else {
            return nil
        }
        
        return createNotice(data)
    }
    
}
