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
        
        return dataSource.sendPostRequest(to: apiEndPoint, params: params, resultType: PostResponseDTO.self)
            .map {
                if $0.result.resultCode == 200 {
                    return true
                }
                
                return false
            }
            .eraseToAnyPublisher()
            
    }
}
