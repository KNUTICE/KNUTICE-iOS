//
//  MainNoticesMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Combine
import Factory
import XCTest
@testable import KNUTICE

final class MockMainNoticesTest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockTopThreeNoticesURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        cancellables = nil
    }

    func testFetchTopThreeNotices_ReturnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch top three notices")
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.mainNoticeURL, resultType: MainNoticeResponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                //Then
                XCTAssertEqual($0.result.resultCode, 200)
                XCTAssertEqual($0.body.latestThreeGeneralNews.count, 3)
                XCTAssertEqual($0.body.latestThreeAcademicNews.count, 3)
                XCTAssertEqual($0.body.latestThreeScholarshipNews.count, 3)
                XCTAssertEqual($0.body.latestThreeEventNews.count, 3)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

}
