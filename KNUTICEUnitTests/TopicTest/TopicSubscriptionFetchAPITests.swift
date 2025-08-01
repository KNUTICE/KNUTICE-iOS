//
//  TopicAPITests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/8/25.
//

import Alamofire
import Factory
import XCTest
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
        guard let endpoint = Bundle.main.notificationPermissionURL else {
            XCTFail("Failed to load notificationPermissionURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        MockURLProtocol.setUpMockData(.fetchTopicSubscriptionsShouldSucceed)
        
        //When
        let dto = try await dataSource.request(
            endpoint,
            method: .get,
            decoding: NotificationSubscriptionDTO.self
        )
        let result = [
            dto.body.generalNewsTopic,
            dto.body.academicNewsTopic,
            dto.body.scholarshipNewsTopic,
            dto.body.eventNewsTopic,
            dto.body.employmentNewsTopic
        ].allSatisfy {
            $0 == true
        }
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_updateTopicSubscription_returnsSuccessDTO() async throws {
        //Given
        guard let endpoint = Bundle.main.notificationPermissionURL else {
            XCTFail("Failed to load notificationPermissionURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed)
        let params: [String: Any] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "fcmToken": "string",
                "noticeName" : "GENERAL_NEWS",
                "isSubscribed" : true
            ]
        ]
        
        //When
        let dto = try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self
        )
        
        //Then
        XCTAssertTrue(dto.body == true)
    }

}
