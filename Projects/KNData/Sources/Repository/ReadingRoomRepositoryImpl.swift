//
//  ReadingRoomRepositoryImpl.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Factory
import Foundation
import KNDomain
import KNNetwork

public final class ReadingRoomRepositoryImpl: ReadingRoomRepository {
    @Injected(\.remoteDataSource) private var remoteDataSource
    
    public init() {}
    
    public func fetchReadingRoomStatus() async throws -> [ReadingRoomStatus] {
        guard let baseURL = Bundle.module.readingRoomURL else { throw NetworkError.invalidURL(message: "BaseURL is missing in the bundle configuration.") }
        
        let dto = try await remoteDataSource.request(
            baseURL + "/status",
            method: .get,
            decoding: ReadingRoomStatusDTO.self,
            useFCMToken: true
        )
        
        return dto.toDomain
    }
    
}
