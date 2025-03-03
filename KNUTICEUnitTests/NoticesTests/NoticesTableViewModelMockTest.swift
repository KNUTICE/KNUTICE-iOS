//
//  NoticesTableViewModelMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class NoticesTableViewModelMockTest: XCTestCase {
    private var viewModel: NoticeTableViewModel!
    private var configuration: URLSessionConfiguration!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        configuration = URLSessionConfiguration.default
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        configuration = nil
        disposeBag = nil
    }
    
    func testFetchGeneralNotices_ReturnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        configuration.protocolClasses = [GeneralNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = NoticeTableViewModel(category: .generalNotice)
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
        
    }
    
    func testFetchAcademicNotices_ReturnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        configuration.protocolClasses = [AcademicNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = NoticeTableViewModel(category: .academicNotice)
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }

    func testFetchScholarshipNotices_ReturnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        configuration.protocolClasses = [ScholarshipNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = NoticeTableViewModel(category: .scholarshipNotice)
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEventNotices_ReturnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        configuration.protocolClasses = [EventNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = NoticeTableViewModel(category: .eventNotice)
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
}
