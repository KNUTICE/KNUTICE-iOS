//
//  MainNoticeTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/24/24.
//

import XCTest
#if DEV
@testable import KNUTICE_dev
#else
@testable import KNUTICE
#endif

final class MainNoticeTest: XCTestCase {
    private var mainNoticeDatasource: MainNoticeDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mainNoticeDatasource = MainNoticeDataSourceImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetch_mainNotice() throws {
        //Given
        let expectation = XCTestExpectation()
        
        //When - 메인 공지사항 요청 테스트
        mainNoticeDatasource.fetchMainNotices()
            .subscribe(onNext: {
                //Then
                let result = try? $0.get()
                
                XCTAssertEqual(result?.result.resultCode, 200)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 10)
    }
}

