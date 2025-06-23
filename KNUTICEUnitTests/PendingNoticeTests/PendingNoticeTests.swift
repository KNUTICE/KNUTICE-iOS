//
//  PendingNoticeTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/15/25.
//

import XCTest
@testable import KNUTICE

final class PendingNoticeTests: XCTestCase {
    private var dataSource: PendingNoticeDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = PendingNoticeDataSource.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_savePendingNotice_withValidId_savesSuccessfully() {
        let expectation = XCTestExpectation(description: "save pending notice id")
        
        Task {
            do {
                try await dataSource.save(id: 1234)
            } catch {
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchPendingNotice_returnsIds() {
        let expectation = XCTestExpectation(description: "fetch pending notice ids")
        
        Task {
            do {
                let ids = try await dataSource.fetchAll()
                
                XCTAssertEqual(ids.count, 0)
            } catch {
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_deletePendingNotice_withValidId_deletesSuccessfully() {
        let expectation = XCTestExpectation(description: "delete pending notice")
        
        Task {
            do {
                try await dataSource.delete(withId: 1234)
            } catch {
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
