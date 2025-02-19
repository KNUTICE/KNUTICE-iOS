//
//  MainNoticeTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/24/24.
//

import XCTest
import Combine
import Factory
@testable import KNUTICE

final class MainNoticeTests: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var viewModel: MainViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = Container.shared.remoteDataSource()
        viewModel = Container.shared.mainViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_fetch_mainNotice() {
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
    
    func test_fetch_mainNotice_withCombine() {
        //Given
        let expectation = XCTestExpectation()
        let url = Bundle.main.mainNoticeURL
        
        //When - 메인 공지사항 요청 테스트
        dataSource.sendGetRequest(to: url, resultType: MainNoticeResponseDTO.self)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: {
                //Then
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testViewModelWiithRxSwift() {
        //Given
        let expectation = XCTestExpectation()
        let _ = viewModel.notices
            .skip(2)
            .subscribe(onNext: {
                //Then
                XCTAssertFalse($0.isEmpty)
                expectation.fulfill()
            })
        
        //When
        viewModel.fetchNotices()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testViewModelWithCombine() {
        //Given
        let expectation = XCTestExpectation()
        let _ = viewModel.notices
            .skip(2)
            .subscribe(onNext: {
                //Then
                XCTAssertFalse($0.isEmpty)
                expectation.fulfill()
            })
        
        //When
        viewModel.fetchNoticesWithCombine()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testViewModelPerformanceWithRxSwift() {
        self.measure {
            testViewModelWiithRxSwift()
        }
    }
    
    func testViewModelPerformanceWithCombine() {
        self.measure {
            testViewModelWithCombine()
        }
    }
}

