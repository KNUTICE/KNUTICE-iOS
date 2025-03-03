//
//  NoticesTableViewModelTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class NoticesTableViewModelTest: XCTestCase {
    private var viewModel: NoticeTableViewModel!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        disposeBag = nil
    }
    
    func testViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        let configuration = URLSessionConfiguration.default
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

}
