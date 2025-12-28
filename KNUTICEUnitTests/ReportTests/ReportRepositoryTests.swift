//
//  ReportRepositoryTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/15/25.
//

import Alamofire
import Factory
import Foundation
import Testing
import KNUTICECore
@testable import KNUTICE

@Test
func submitReport() async throws {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    
    let session = Session(configuration: configuration)
    
    Container.shared.remoteDataSource.register {
        RemoteDataSourceImpl(session: session)
    }
    
    guard let endpoint = Bundle.main.reportURL else {
        throw NetworkError.invalidURL(message: "Invalid or missing report URL.")
    }
    
    MockURLProtocol.setUpMockData(.submitReportShouldSucceed, for: URL(string: endpoint)!)
    
    let repository = Container.shared.reportRepository()
    try await repository.register(params: [:])
}
