//
//  NoticesCollectionViewModelTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class NoticesCollectionViewModelTests: XCTestCase {
    private var viewModel: NoticeCollectionViewModel!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        disposeBag = nil
    }
    
    func test_fetchGeneralNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        MockURLProtocol.setUpMockData(.fetchGeneralNoticesShouldSucceed)
        viewModel = NoticeCollectionViewModel(category: .generalNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
        
    }
    
    func test_fetchAcademicNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        MockURLProtocol.setUpMockData(.fetchAcademicNoticesShouldSucceed)
        viewModel = NoticeCollectionViewModel(category: .academicNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchScholarshipNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        MockURLProtocol.setUpMockData(.fetchScholarshipNoticesShouldSucceed)
        viewModel = NoticeCollectionViewModel(category: .scholarshipNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchEventNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        MockURLProtocol.setUpMockData(.fetchEventNoticesShouldSucceed)
        viewModel = NoticeCollectionViewModel(category: .eventNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 20)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchEmploymentNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        MockURLProtocol.setUpMockData(.fetchEmploymentNoticesShouldSucceed)
        viewModel = NoticeCollectionViewModel(category: .employmentNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 4)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
}
