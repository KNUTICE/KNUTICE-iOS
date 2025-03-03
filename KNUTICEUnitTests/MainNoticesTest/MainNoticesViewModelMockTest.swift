//
//  MainNoticesViewModelMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class MainNoticesViewModelMockTest: XCTestCase {
    private var viewModel: MainViewModel!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [TopThreeNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = Container.shared.mainViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        disposeBag = nil
    }
    
    func testFetchTopThreeNotices_ReturnNotices() {
        //Given
        let expectation = expectation(description: "fetch top three notices")
        viewModel.notices
            .skip(2)
            .subscribe(onNext: {
                //Then
                XCTAssertEqual($0[0].items.count, 3)
                XCTAssertEqual($0[1].items.count, 3)
                XCTAssertEqual($0[2].items.count, 3)
                XCTAssertEqual($0[3].items.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        //When
        viewModel.fetchNoticesWithCombine()
        wait(for: [expectation], timeout: 1)
    }

}
