//
//  NoticesCollectionViewModelTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import KNUTICECore
import RxSwift
import XCTest
@testable import KNUTICE

final class NoticesCollectionViewModelTests: XCTestCase {
    private var viewModel: NoticeCollectionViewModel!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Container.shared.noticeRepository.register {
            MockNoticeRepository()
        }
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        disposeBag = nil
    }
    
    @MainActor
    func test_fetchGeneralNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        
        viewModel = NoticeCollectionViewModel(category: .generalNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
        
    }
    
    @MainActor
    func test_fetchAcademicNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch academic notices")
        
        viewModel = NoticeCollectionViewModel(category: .academicNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_fetchScholarshipNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch scholarship notices")

        viewModel = NoticeCollectionViewModel(category: .scholarshipNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor
    func test_fetchEventNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch event notices")
        
        viewModel = NoticeCollectionViewModel(category: .eventNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor
    func test_fetchEmploymentNotices_returnNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch employment notices")
        
        viewModel = NoticeCollectionViewModel(category: .employmentNotice)
        
        viewModel.notices
            .skip(1)
            .subscribe(onNext: { notices in
                //Then
                XCTAssertEqual(notices.flatMap { $0.items }.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1)
    }
}
