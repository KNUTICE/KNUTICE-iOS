//
//  ReportRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine
import Foundation
import Factory
import KNUTICECore

final class ReportRepositoryImpl: ReportRepository {
    @Injected(\.remoteDataSource) var dataSource: RemoteDataSource
    
    func register(params: [String: any Sendable]) -> AnyPublisher<Bool, any Error> {
        guard let endpoint = Bundle.main.reportURL else {
            return Fail(error: NetworkError.invalidURL(message: "Invalid or missing report URL."))
                .eraseToAnyPublisher()
        }
        
        return dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
        .flatMap { dto -> AnyPublisher<Bool, any Error> in
            guard dto.code == 200 else {
                return Fail(error: RemoteServerError.invalidResponse(message: dto.message))
                    .eraseToAnyPublisher()
            }
            
            return Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
