//
//  NotificationSubscriptionListViewModelTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/8/25.
//

import Alamofire
import Combine
import Factory
import XCTest
import KNUTICECore
@testable import KNUTICE

@MainActor
final class TopicSubscriptionListViewModelTest: XCTestCase {
    private var viewModel: TopicSubscriptionListViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = TopicSubscriptionListViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        viewModel = nil
        cancellables = nil
    }
    
    func test_fetchTopicSubscribeStatus_returnsExpectedResult() {
        //Given
        let expectation = expectation(description: "fetch subscription status")
        MockURLProtocol.setUpMockData(.fetchTopicSubscriptionsShouldSucceed)
        Publishers.MergeMany(
            viewModel.$isGeneralNoticeNotificationSubscribed,
            viewModel.$isAcademicNoticeNotificationSubscribed,
            viewModel.$isScholarshipNoticeNotificationSubscribed,
            viewModel.$isEventNoticeNotificationSubscribed,
            viewModel.$isEmploymentNoticeNotificationSubscribed
        )
        .collect(5)
        .dropFirst()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }, receiveValue: {
            //Then
            XCTAssertTrue($0.allSatisfy { $0 == true })
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        //When
        Task {
            await viewModel.fetchNotificationSubscriptions()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_updateTopicSubscription_returnsExpectedResult() {
        //Given
        let expectation = expectation(description: "update subscription status")
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed)
        Publishers.MergeMany(
            viewModel.$isGeneralNoticeNotificationSubscribed,
            viewModel.$isAcademicNoticeNotificationSubscribed,
            viewModel.$isScholarshipNoticeNotificationSubscribed,
            viewModel.$isEventNoticeNotificationSubscribed,
            viewModel.$isEmploymentNoticeNotificationSubscribed
        )
        .collect(5)
        .dropFirst()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }, receiveValue: {
            //Then
            XCTAssertTrue($0.allSatisfy { $0 == false })
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        //When
        Task {
            let keys: [NoticeCategory] = [
                .generalNotice,
                .academicNotice,
                .scholarshipNotice,
                .eventNotice,
                .employmentNotice
            ]
            
            await withTaskGroup(of: Void.self) { group in
                for key in keys {
                    group.addTask {
                        await self.viewModel.update(key: key, value: false)
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
