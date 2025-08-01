//
//  SearchedNoticesMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Combine
import Factory
import XCTest
@testable import KNUTICE

final class MockSearchedNoticesAPITest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        cancellables = []
        MockURLProtocol.setUpMockData(.fetchSearchedNoticesShouldSucceed)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        cancellables = nil
    }

    func test_fetchNotices_returnNoticeReponseDTO() {
        //Given
        guard let endpoint = Bundle.main.searchURL else {
            XCTFail("Failed to load searchURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        let expectation = expectation(description: "fetch searched notices")
        
        //When
        dataSource.request(endpoint + "?keyword=공지", method: .get, decoding: NoticeReponseDTO.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }, receiveValue: {
                //Then
                XCTAssertEqual($0.result.resultCode, 200)
                XCTAssertNotNil($0.body)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

}
