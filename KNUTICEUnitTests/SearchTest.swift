//
//  SearchTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/22/24.
//

import XCTest
import Combine
@testable import KNUTICE

final class SearchTest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = RemoteDataSourceImpl.shared
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_withRx() {
        //Given
        let expectation = XCTestExpectation(description: "network request test")
        let url = Bundle.main.searchURL + "?keyword=공지"
        
        //When
        let _ = dataSource.sendGetRequest(to: url, resultType: NoticeReponseDTO.self)
            .subscribe(onSuccess: { dto in
                //Then
                XCTAssertEqual(dto.result.resultCode, 200)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_withCombine() {
        //Given
        let expectation = XCTestExpectation(description: "network request test")
        let url = Bundle.main.searchURL + "?keyword=공지"
        
        //When
        dataSource.sendGetRequest(to: url, resultType: NoticeReponseDTO.self)
            .sink {
                print($0)
            } receiveValue: {
                //Then
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRxPerformance() {
        self.measure {
            test_withRx()
        }
    }
    
    func testCombinePerformance() {
        self.measure {
            test_withCombine()
        }
    }
}
