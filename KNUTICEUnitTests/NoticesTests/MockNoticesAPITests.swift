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
    private var configuration: URLSessionConfiguration!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        configuration = URLSessionConfiguration.default
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        configuration = nil
        cancellables = nil
    }

    func test_FetchGeneralNotices_ReturnNoticesDTO() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        configuration.protocolClasses = [MockGeneralNoticesURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.generalNoticeURL, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                //Then
                XCTAssertTrue($0.body?.count == 20)
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchAcademicNotices_ReturnNoticesDTO() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        configuration.protocolClasses = [MockAcademicNoticesURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.academicNoticeURL, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                XCTAssertEqual($0.body?.count, 20)
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchScholarshipNotices_ReturnNoticesDTO() {
        //Given
        let expectation = XCTestExpectation(description: "fetch scholarship notices")
        configuration.protocolClasses = [MockScholarshipNoticesURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.scholarshipNoticeURL, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                XCTAssertEqual($0.body?.count, 20)
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_FetchEventNotices_ReturnNoticesDTO() {
        let expectation = XCTestExpectation(description: "fetch event notices")
        configuration.protocolClasses = [MockEventNoticesURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.eventNoticeURL, resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                XCTAssertEqual($0.body?.count, 20)
                XCTAssertEqual($0.result.resultCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
