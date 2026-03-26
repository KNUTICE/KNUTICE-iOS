//
//  NoticeSummaryRepositories.swift
//  KNNoticeSummary
//
//  Created by 이정훈 on 1/29/26.
//

import Factory
import Foundation
import KNNetwork

actor NoticeSummaryRepositoryImpl: NoticeSummaryRepository {
    @Injected(\.remoteDataSource) private var remoteDataSource
    
    func fetch(for nttId: Int) async throws -> NoticeSummary {
        guard var baseURL = Bundle.knIntelligence.noticeSummaryURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing 'Notice_Summary_URL' in resource.")
        }
        
        baseURL += "/\(nttId)"
        
        let dto = try await remoteDataSource.request(
            baseURL,
            method: .get,
            decoding: NoticeSummaryDTO.self
        )
        
        return NoticeSummary(id: dto.data.nttID, content: dto.data.contentSummary)
    }
    
}
