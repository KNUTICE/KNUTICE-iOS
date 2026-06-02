//
//  NoticeSummaryTests.swift
//  KNIntelligenceTests
//
//  Created by 이정훈 on 3/17/26.
//

import Alamofire
import Foundation
@testable import KNData
import Testing
import KNNetwork

@Suite("공지 AI 요약 API 테스트")
struct NoticeSummaryTests {
    // MARK: - Properties
    private let dataSource: any RemoteDataSource
    private let baseURL: String
    
    init() throws {
        // Configure Session
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        
        let dataSource = RemoteDataSourceImpl(session: session)
        self.dataSource = dataSource
        
        guard let url = Bundle.knData.noticeSummaryURL else {
            throw NetworkError.invalidURL(
                message: "Failed to load baseURL from Bundle.knIntelligence. " +
                "Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension."
            )
        }
        self.baseURL = url
    }
    
    // MARK: - Tests
    
    @Test("공지 AI 요약 조회 성공 - 200")
    func fetchNoticeSummary_shouldSuccess() async throws {
        // Given
        MockURLProtocol.setUpMockData(.fetchNoticeSummaryShouldSucceed, for: URL(string: baseURL)!)
        
        // When
        let dto = try await dataSource.request(baseURL, method: .get, decoding: NoticeSummaryDTO.self)
        
        // Then
        #expect(dto.metaData.success == true)
        #expect(dto.metaData.code == 200)
        #expect(dto.metaData.message == nil)
        #expect(dto.data.nttID == 1087050)
        #expect(dto.data.contentSummary.isEmpty == false)
    }

}
