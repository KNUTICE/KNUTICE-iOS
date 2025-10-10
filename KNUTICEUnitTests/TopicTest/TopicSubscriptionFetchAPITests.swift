//
//  TopicAPITests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/8/25.
//

import Alamofire
import Factory
import XCTest
import KNUTICECore
@testable import KNUTICE

final class TopicSubscriptionFetchAPITests: XCTestCase {
    private var dataSource: RemoteDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_fetchTopicSubscriptionsStatus_returnsNotificationSubscriptionDTO() async throws {
        //Given
        guard let endpoint = Bundle.main.topicSubscriptionURL else {
            XCTFail("Failed to load notificationPermissionURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        MockURLProtocol.setUpMockData(.fetchTopicSubscriptionsShouldSucceed, for: URL(string: endpoint)!)
        
        //When
        let dto = try await dataSource.request(
            endpoint,
            method: .get,
            decoding: TopicSubscriptionResponseDTO.self
        )
        let result = dto.data.subscribedTopics.allSatisfy {
            ["GENERAL_NEWS", "SCHOLARSHIP_NEWS", "EVENT_NEWS", "ACADEMIC_NEWS", "EMPLOYMENT_NEWS"].contains($0)
        }
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_updateTopicSubscription_returnsSuccessDTO() async throws {
        //Given
        guard let endpoint = Bundle.main.topicSubscriptionURL else {
            XCTFail("Failed to load notificationPermissionURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed, for: URL(string: endpoint)!)
        
        let params = [
            "topic": "GENERAL_NEWS",
            "enabled": true
        ] as [String: any Sendable]
        
        //When
        let dto = try await dataSource.request(
            endpoint,
            method: .patch,
            parameters: params,
            decoding: PostResponseDTO.self
        )
        
        //Then
        XCTAssertTrue(dto.data == true)
    }

}
