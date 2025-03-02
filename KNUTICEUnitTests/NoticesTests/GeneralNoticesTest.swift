//
//  GeneralNoticesTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Alamofire
import Combine
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class GeneralNoticesTest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var viewModel: NoticeTableViewModel!
    private var cancellables: Set<AnyCancellable>!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [GeneralNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        viewModel = NoticeTableViewModel(category: .generalNotice)
        cancellables = []
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        viewModel = nil
        cancellables = nil
        disposeBag = nil
    }

    func testFetchGeneralNotices() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
        
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
    
    func testViewModel() {
        //Given
        let expectation = XCTestExpectation(description: "fetch general notices")
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
