//
//  MainNoticeTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/24/24.
//

import XCTest
@testable import KNUTICE

final class MainNoticeTest: XCTestCase {
    private var dataSource: RemoteDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = RemoteDataSourceImpl.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetch_mainNotice() throws {
        //Given
        let expectation = XCTestExpectation()
        let url = Bundle.main.mainNoticeURL
        
        //When - 메인 공지사항 요청 테스트        
        let _ = dataSource.sendGetRequest(to: url, resultType: MainNoticeResponseDTO.self)
            .subscribe {
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
    }
}

