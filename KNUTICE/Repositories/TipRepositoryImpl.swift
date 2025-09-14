//
//  TipRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Factory
import Foundation
import KNUTICECore

actor TipRepositoryImpl: TipRepository {
    @Injected(\.remoteDataSource) private var dataSource
    
    func fetchTips() async -> Result<[Tip]?, any Error> {
        guard let baseURL = Bundle.main.tipURL else {
            return .failure(NetworkError.invalidURL(message: "The tip API URL is missing or invalid."))
        }
        
        do {
            try Task.checkCancellation()
            
            let endpoint = baseURL + "?deviceType=iOS"
            let dto = try await dataSource.request(endpoint, method: .get, decoding: TipResponseDTO.self)
            let tips = dto.data?.map {
                Tip(id: $0.tipID, title: $0.title, contentURL: $0.url)
            }
            
            return .success(tips)
        } catch {
            return .failure(error)
        }
    }
}
