//
//  SearchTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/22/24.
//

import XCTest
@testable import KNUTICE

final class SearchTest: XCTestCase {
    private var dataSource: RemoteDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = RemoteDataSourceImpl.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_network_request() throws {
        //Given
        let expectation = XCTestExpectation(description: "netword request test")
        let url = Bundle.main.searchURL + "?keyword=공지"
        
        //When
        let _ = dataSource.sendGetRequest(to: url, resultType: NoticeReponseDTO.self)
            .subscribe(onSuccess: { dto in
                XCTAssertEqual(dto.result.resultCode, 200)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 10)
    }
}
