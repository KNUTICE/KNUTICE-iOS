//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Combine
//import Factory
import Foundation

public final class NoticeRepositoryImpl: NoticeRepository, NoticeCreatable {
    private let dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.standard.noticeURL
    
    init(dataSource: RemoteDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error> {
        guard let baseURL = baseURL else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource."))
                .eraseToAnyPublisher()
        }
        
        return dataSource.request(
            baseURL + "?noticeName=\(category.rawValue)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        .compactMap { [weak self] dto in
            dto.body?.compactMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error> {
        guard let baseURL = baseURL else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource."))
                .eraseToAnyPublisher()
        }
        
        return dataSource.request(
            baseURL + "?noticeName=\(category.rawValue)" + "&nttId=\(number)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        .compactMap { [weak self] dto in
            dto.body?.compactMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
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
            return dto.body.flatMap {
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
        
        guard let body = dto.body else {
            return nil
        }
        
        return createNotice(body)
    }
    
    public func fetchNotices(for category: NoticeCategory, size: Int = 20) async throws -> [Notice] {
        guard let baseURL = baseURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource.")
        }
        
        try Task.checkCancellation()
        
        let dto = try await dataSource.request(
            baseURL + "?noticeName=\(category.rawValue)" + "&size=\(size)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        let notices = dto.body?.compactMap {
            createNotice($0)
        } ?? []
        
        return notices
    }
}
