//
//  GeneralNoticeTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/24/24.
//

import XCTest
import Foundation
@testable import KNUTICE

final class NoticeTest: XCTestCase {
    private var noticeDataSource: NoticeDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        noticeDataSource = NoticeDataSourceImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetch_genernal_notice() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        
        //When - 일반 공지 요청 테스트
        let  _ = noticeDataSource.fetchNotices(from: Bundle.main.generalNoticeURL)
            .subscribe {
                //Then - 성공 여부 확인
                let result = try? $0.get()
                
                XCTAssertEqual(result?.result.resultCode, 200)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_fetch_academic_notice() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        
        //When - 학사 공지 요청 테스트
        let _ = noticeDataSource.fetchNotices(from: Bundle.main.academicNoticeURL)
            .subscribe {
                //Then - 성공 여부 확인
                let result = try? $0.get()
                
                XCTAssertEqual(result?.result.resultCode, 200)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_fetch_scholarship_notice() {
        //Given
        let expectation = XCTestExpectation(description: "fetch scholarship notices")
        
        //When - 장학 공지 요청 테스트
        let _ = noticeDataSource.fetchNotices(from: Bundle.main.scholarshipNoticeURL)
            .subscribe {
                //Then - 성공 여부 확인
                let result = try? $0.get()
                
                XCTAssertEqual(result?.result.resultCode, 200)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_fetch_event_notice() {
        //Given
        let expectation = XCTestExpectation(description: "fetch event notices")
        
        //When - 이벤트 공지 요청 테스트
        let _ = noticeDataSource.fetchNotices(from: Bundle.main.eventNoticeURL)
            .subscribe {
                //Then - 성공 여부 확인
                let result = try? $0.get()
                
                XCTAssertEqual(result?.result.resultCode, 200)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
    }
}
