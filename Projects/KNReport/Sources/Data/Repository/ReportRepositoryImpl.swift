//
//  ReportRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine
import Foundation
import Factory
import KNNetwork
import KNUtility

actor ReportRepositoryImpl: ReportRepository {
    
    @Injected(\.remoteDataSource) var dataSource: RemoteDataSource
    
    func register(params: [String : any Sendable]) async throws {
        guard let endpoint = Bundle.module.reportURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing report URL.")
        }
        
        try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self,
            isInterceptable: true
        )
    }
    
}
