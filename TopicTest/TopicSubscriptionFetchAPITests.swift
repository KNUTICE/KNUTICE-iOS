//
//  TopicAPITests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/8/25.
//

import Alamofire
import Combine
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
        MockURLProtocol.setUpMockData(.fetchTopicSubscriptionsShouldSucceed)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_fetchTopicSubscriptionsStatus_returnsNotificationSubscriptionDTO() {
        //Given
        let expectation = expectation(description: "fetch topic subscriptions status")
        
        Task {
            do {
                //When
                let dto = try await dataSource.request(
                    Bundle.main.notificationPermissionURL,
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
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
