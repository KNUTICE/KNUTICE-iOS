//
//  TipAPITest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/9/25.
//

import Alamofire
import Factory
import Foundation
import KNUTICECore
import Testing
@testable import KNUTICE

@Test
func fetchTipDTO() async throws {
    // Configurate Session
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    
    let session = Session(configuration: configuration)
    
    Container.shared.remoteDataSource.register {
        RemoteDataSourceImpl(session: session)
    }
    
    let dataSource = Container.shared.remoteDataSource()
    
    guard let endpoint = Bundle.main.tipURL else {
        throw NetworkError.invalidURL(
            message: "Failed to load tipURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension."
        )
    }
    
    // Set up mock data
    MockURLProtocol.setUpMockData(.fetchTipsShouldSucceed, for: URL(string: endpoint)!)
    
    let dto = try await dataSource.request(
        endpoint,
        method: .get,
        decoding: TipResponseDTO.self
    )
    
    #expect(dto.data?.count == 1)
}
