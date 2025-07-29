//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine
import Factory
import Foundation

final class NoticeRepositoryImpl: NoticeRepository, NoticeCreatable {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    private let baseURL: String? = Bundle.main.noticeURL
    
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error> {
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
    
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error> {
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
    
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error> {
        guard let baseURL = baseURL else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing 'Notice_URL' in resource."))
                .eraseToAnyPublisher()
        }
        
        let params: [String: Any] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "nttIdList": nttIds
            ]
        ]
        
        return dataSource.request(
            baseURL + "/sync",
            method: .post,
            parameters: params,
            decoding: NoticeReponseDTO.self
        )
        .compactMap { [weak self] dto in
            dto.body?.compactMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error> {
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
    
    func fetchNotice(by nttId: Int) async throws -> Notice? {
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
}
