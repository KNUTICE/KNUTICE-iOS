//
//  MainPopupContentRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore

final class MainPopupContentRepositoryImpl: MainPopupContentRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func fetchMainPopupContent() -> AnyPublisher<MainPopupContent?, any Error> {
        guard let apiEndPoint = Bundle.main.mainPopupContentURL else {
            return Fail(error: NetworkError.invalidURL(message: "The urgent API URL is missing or invalid."))
                .eraseToAnyPublisher()
        }
        
        return dataSource.request(
            apiEndPoint,
            method:. get,
            decoding: MainPopupContentDTO.self
        )
        .compactMap { [weak self] in
            self?.createMainPopupContent(from: $0)
        }
        .eraseToAnyPublisher()
    }
}
