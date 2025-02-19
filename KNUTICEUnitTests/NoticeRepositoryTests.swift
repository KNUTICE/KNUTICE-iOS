//
//  NoticeRepositoryTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/19/25.
//

import XCTest
import Combine
import Factory
@testable import KNUTICE

final class NoticeRepositoryTests: XCTestCase {
    private var noticeRepository: NoticeRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        noticeRepository = Container.shared.noticeRepository()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        noticeRepository = nil
        cancellables = nil
    }

    func testFetchNotices() throws {
        //Given
        let expectation = XCTestExpectation(description: "fetch notices by nttIds")
        
        //When
        let _ = noticeRepository.fetchNotices(by: [1077315, 1077210])
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                //Then
                XCTAssertTrue(!$0.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }

}
