//
//  SearchTableViewModelTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 5/23/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class SearchTableViewModelTest: XCTestCase {
    private var viewModel: SearchTableViewModel!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = SearchTableViewModel()
        disposeBag = DisposeBag()
        MockURLProtocol.setUpMockData(.fetchSearchedNoticesShouldSucceed)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        viewModel = nil
        disposeBag = nil
    }

    func test_fetchSearchedNotices_returnNoticeResponseDTO() {
        //Given
        let expectation = expectation(description: "fetch searched notices")
        viewModel.notices
            .skip(1)
            .subscribe(onNext: {
                //Then
                XCTAssertNotNil($0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.search("공지")
        
        wait(for: [expectation], timeout: 1)
    }

}
