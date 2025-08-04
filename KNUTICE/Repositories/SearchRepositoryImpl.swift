//
//  SearchRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import RxSwift
import Foundation
import Factory

final class SearchRepositoryImpl: SearchRepository, NoticeCreatable {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func search(keyword: String) -> Single<[Notice]> {
        guard let baseURL = Bundle.main.searchURL else {
            return Single.error(NetworkError.invalidURL(message: "The search API URL is missing or invalid."))
        }
        
        return dataSource.request(
            baseURL + "?keyword=\(keyword)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        .map { [weak self] dto in
            return dto.body?.compactMap {
                self?.createNotice($0)
            } ?? []
        }
    }
    
    func search(with keyword: String) async throws -> [Notice] {
        guard let baseURL = Bundle.main.searchURL else {
            throw NetworkError.invalidURL(message: "The search API URL is missing or invalid.")
        }
        
        try Task.checkCancellation()
        
        let dto = try await dataSource.request(
            baseURL + "?keyword=\(keyword)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        
        return dto.body?.compactMap {
            createNotice($0)
        } ?? []
    }
}
