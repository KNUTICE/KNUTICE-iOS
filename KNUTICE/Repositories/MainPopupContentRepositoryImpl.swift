//
//  MainPopupContentRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import Foundation

final class MainPopupContentRepositoryImpl<T: RemoteDataSource>: MainPopupContentRepository {
    private let dataSource: T
    
    init(dataSource: T) {
        self.dataSource = dataSource
    }
    
    func fetchMainPopupContent() -> AnyPublisher<MainPopupContent?, any Error> {
        let apiEndPoint = Bundle.main.mainPopupContentURL
        return dataSource.sendGetRequest(to: apiEndPoint, resultType: MainPopupContentDTO.self)
            .map {
                self.createMainPopupContent(from: $0)
            }
            .eraseToAnyPublisher()
    }
}
