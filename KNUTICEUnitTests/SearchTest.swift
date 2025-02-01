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
    private var viewModel: SearchTableViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = RemoteDataSourceImpl.shared
        viewModel = AppDI.shared.makeSearchTableViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
        viewModel = nil
        cancellables = nil
    }
    
    func testNetworkRequestWithRx() {
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
    
    func testNetworkRequestWithCombine() {
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
            testNetworkRequestWithRx()
        }
    }
    
    func testCombinePerformance() {
        self.measure {
            testNetworkRequestWithCombine()
        }
    }
    
    func testViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "ViewModel Test")
        let _ = viewModel.notices
            .skip(1)
            .subscribe {
                //Then
                if let element = $0.element, let notices = element {
                    XCTAssertTrue(!notices.isEmpty)
                } else {
                    XCTFail("Expected element and notices to be non-nil, but got nil.")
                }
                expectation.fulfill()
            }
        
        //When
        viewModel.search("공지")
        
        wait(for: [expectation], timeout: 10)
    }
}
