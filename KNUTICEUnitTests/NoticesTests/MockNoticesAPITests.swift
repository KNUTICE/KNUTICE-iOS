//
//  GeneralNoticesTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Alamofire
import Combine
import Factory
import XCTest
@testable import KNUTICE

final class MockNoticesAPITests: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        cancellables = nil
    }

    func test_FetchGeneralNotices_ReturnNoticesDTO() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        let endPoint = Bundle.main.noticeURL + "?noticeName=\(NoticeCategory.generalNotice.rawValue)"
        MockURLProtocol.setUpMockData(.fetchGeneralNoticesShouldSucceed)
        
        //When
        dataSource.sendGetRequest(to: endPoint, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }, receiveValue: {
                //Then
                XCTAssertTrue($0.body?.count == 20)
                XCTAssertEqual($0.result.resultCode, 200)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchAcademicNotices_ReturnNoticesDTO() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        let endPoint = Bundle.main.noticeURL + "?noticeName=\(NoticeCategory.academicNotice.rawValue)"
        MockURLProtocol.setUpMockData(.fetchAcademicNoticesShouldSucceed)
        
        //When
        dataSource.sendGetRequest(to: endPoint, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }, receiveValue: {
                XCTAssertEqual($0.body?.count, 20)
                XCTAssertEqual($0.result.resultCode, 200)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchScholarshipNotices_ReturnNoticesDTO() {
        //Given
        let expectation = XCTestExpectation(description: "fetch scholarship notices")
        let endPoint = Bundle.main.noticeURL + "?noticeName=\(NoticeCategory.scholarshipNotice.rawValue)"
        MockURLProtocol.setUpMockData(.fetchScholarshipNoticesShouldSucceed)
        
        //When
        dataSource.sendGetRequest(to: endPoint, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }, receiveValue: {
                XCTAssertEqual($0.body?.count, 20)
                XCTAssertEqual($0.result.resultCode, 200)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_FetchEventNotices_ReturnNoticesDTO() {
        let expectation = XCTestExpectation(description: "fetch event notices")
        let endPoint = Bundle.main.noticeURL + "?noticeName=\(NoticeCategory.eventNotice.rawValue)"
        MockURLProtocol.setUpMockData(.fetchEventNoticesShouldSucceed)
        
        //When
        dataSource.sendGetRequest(to: endPoint, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("\(error)")
                }
            }, receiveValue: {
                XCTAssertEqual($0.body?.count, 20)
                XCTAssertEqual($0.result.resultCode, 200)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
