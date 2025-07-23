//
//  TipRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Factory
import Foundation

final class TipRepositoryImpl: TipRepository {
    @Injected(\.remoteDataSource) private var dataSource
    
    func fetchTips() async -> Result<[Tip]?, any Error> {
        let endpoint = Bundle.main.tipURL
        
        do {
            let dto = try await dataSource.request(endpoint, method: .get, decoding: TipDTO.self)
            
            try Task.checkCancellation()
            
            let tips = dto.body?.map {
                Tip(id: $0.id, title: $0.title, contentURL: $0.url)
            }
            
            return .success(tips)
        } catch {
            return .failure(error)
        }
    }
}
