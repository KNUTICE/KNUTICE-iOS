//
//
//  ReportAPITest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/15/25.
//

import Alamofire
import Factory
import Foundation
import Testing
@testable import KNData
import KNNetwork
import KNUtility

@Test
func submitReport() async throws {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    let session = Session(configuration: configuration)
    
    Container.shared.remoteDataSource.register {
        RemoteDataSourceImpl(session: session)
    }
    
    guard let endpoint = Bundle.knData.reportURL else {
        throw NetworkError.invalidURL(message: "Invalid or missing report URL.")
    }
    
    MockURLProtocol.setUpMockData(.submitReportShouldSucceed, for: URL(string: endpoint)!)
    
    let dataSource = Container.shared.remoteDataSource()
    try await dataSource.request(
        endpoint,
        method: .post,
        decoding: PostResponseDTO.self,
        useFCMToken: true
    )
    
    #expect(true)
}
