//
//  TopicUpdateAPITests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/8/25.
//

import Alamofire
import Combine
import Factory
import XCTest
@testable import KNUTICE

final class TopicSubscriptionUpdateAPITests: XCTestCase {
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
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_updateTopicSubscription_returnsSuccessDTO() {
        //Given
        let expectation = XCTestExpectation(description: "update topic subscription")
        
        Task {
            do {
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
                let dto = try await dataSource.request(
                    Bundle.main.notificationPermissionURL,
                    method: .post,
                    parameters: params,
                    decoding: PostResponseDTO.self
                )
                
                XCTAssertTrue(dto.body == true)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
