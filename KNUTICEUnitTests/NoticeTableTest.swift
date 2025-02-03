//
//  GeneralNoticeTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/24/24.
//

import XCTest
import Combine
@testable import KNUTICE

final class NoticeTableTest: XCTestCase {
    private var generalNoticeTableViewModel: NoticeTableViewModel!
    private var academicNoticeTableViewModel: NoticeTableViewModel!
    private var sholarshipNoticeTableViewModel: NoticeTableViewModel!
    private var eventNoticeTableViewModel: NoticeTableViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        generalNoticeTableViewModel = AppDI.shared.createGeneralNoticeTableViewModel()
        academicNoticeTableViewModel = AppDI.shared.createAcademicNoticeTableViewModel()
        sholarshipNoticeTableViewModel = AppDI.shared.createScholarshipNoticeTableViewModel()
        eventNoticeTableViewModel = AppDI.shared.createEventNoticeTableViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        generalNoticeTableViewModel = nil
        academicNoticeTableViewModel = nil
        sholarshipNoticeTableViewModel = nil
        eventNoticeTableViewModel = nil
        cancellables = nil
    }
    
    func testGeneralNoticeTableViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        let _ = generalNoticeTableViewModel.notices
            .skip(1)
            .subscribe {
                //Then
                if let element = $0.element {
                    XCTAssertTrue(!element.isEmpty)
                } else {
                    XCTFail("Expected element to be non-nil, but got nil.")
                }
                expectation.fulfill()
            }
        
        //When
        generalNoticeTableViewModel.fetchNotices()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testAcademicNoticeTableViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        let _ = academicNoticeTableViewModel.notices
            .skip(1)
            .subscribe {
                //Then
                if let element = $0.element {
                    XCTAssertTrue(!element.isEmpty)
                } else {
                    XCTFail("Expected element to be non-nil, but got nil.")
                }
                expectation.fulfill()
            }
        
        //When
        academicNoticeTableViewModel.fetchNotices()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testScholarshipNoticeTableViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        let _ = sholarshipNoticeTableViewModel.notices
            .skip(1)
            .subscribe {
                //Then
                if let element = $0.element {
                    XCTAssertTrue(!element.isEmpty)
                } else {
                    XCTFail("Expected element to be non-nil, but got nil.")
                }
                expectation.fulfill()
            }
        
        //When
        sholarshipNoticeTableViewModel.fetchNotices()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testEventNoticeTableViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        let _ = eventNoticeTableViewModel.notices
            .skip(1)
            .subscribe {
                //Then
                if let element = $0.element {
                    XCTAssertTrue(!element.isEmpty)
                } else {
                    XCTFail("Expected element to be non-nil, but got nil.")
                }
                expectation.fulfill()
            }
        
        //When
        eventNoticeTableViewModel.fetchNotices()
        
        wait(for: [expectation], timeout: 10)
    }
}
