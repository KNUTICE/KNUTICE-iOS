//
//  ReadingRoomRepositoryImpl.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Factory
import Foundation
import KNNetwork

class ReadingRoomRepositoryImpl: ReadingRoomRepository {
    @Injected(\.remoteDataSource) private var remoteDataSource
    
    func fetchReadingRoomStatus() async throws -> [ReadingRoomStatus] {
        guard let baseURL = Bundle.module.baseURL else { throw NetworkError.invalidURL(message: "BaseURL is missing in the bundle configuration.") }
        
        return try await remoteDataSource.request(
            baseURL + "status",
            method: .get,
            decoding: ReadingRoomStatusDTO.self
        )
        .toDomain
    }
    
}
