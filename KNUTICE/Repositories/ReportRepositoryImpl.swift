//
//  ReportRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine
import Foundation
import Factory

final class ReportRepositoryImpl: ReportRepository {
    @Injected(\.remoteDataSource) var dataSource: RemoteDataSource
    
    func register(params: [String: Any]) -> AnyPublisher<Bool, any Error> {
        let apiEndPoint = Bundle.main.reportURL
        
        return dataSource.request(
            apiEndPoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
        .flatMap { dto -> AnyPublisher<Bool, any Error> in
            guard dto.result.resultCode == 200 else {
                return Fail(error: RemoteServerError.invalidResponse(message: dto.result.resultMessage))
                    .eraseToAnyPublisher()
            }
            
            return Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
