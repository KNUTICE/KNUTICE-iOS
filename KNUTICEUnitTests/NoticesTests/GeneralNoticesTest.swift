//
//  GeneralNoticesTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import XCTest
import Alamofire
import Combine
@testable import KNUTICE

final class GeneralNoticesTest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        cancellables = nil
    }

    func testFetchGeneralNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [GeneralNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        dataSource = RemoteDataSourceImpl(session: session)
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.generalNoticeURL, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                //Then
                XCTAssertTrue($0.body?.count == 20)
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
