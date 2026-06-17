//
//  TokenAPITests.swift
//  KNTokenTests
//
//  Created by 이정훈 on 3/26/26.
//

import Alamofire
import Factory
import Foundation
import KNNetwork
@testable import KNData
import Testing

struct TokenRepositoryTests {
    private let baseURL: String? = Bundle.knData.tokenURL
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
    }

    @Test("FCM Token 등록 테스트")
    func registerToken() async throws {
        guard let baseURL else {
            #expect(Bool(false), "tokenURL is not configured.")
            return
        }
        
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed, for: URL(string: baseURL)!)
        
        let repository = TokenRepositoryImpl()
        try await repository.register()
        
        #expect(true)
    }
    
    @Test("FCM Token이 갱신 되었을 때, 갱신 테스트")
    func updateToken() async throws {
        guard let baseURL else {
            #expect(Bool(false), "tokenURL is not configured.")
            return
        }
        
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed, for: URL(string: baseURL)!)
        
        let repository = TokenRepositoryImpl()
        try await repository.update(oldFCMToken: nil, newFCMToken: "")
        
        #expect(true)
    }
    
}
