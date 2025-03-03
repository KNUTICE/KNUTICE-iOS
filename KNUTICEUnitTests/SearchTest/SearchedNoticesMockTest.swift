//
//  SearchedNoticesMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Combine
import Factory
import RxSwift
import XCTest
@testable import KNUTICE

final class SearchedNoticesMockTest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var viewModel: SearchTableViewModel!
    private var cancellables: Set<AnyCancellable>!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [SearchedNoticesMockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        viewModel = SearchTableViewModel()
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

    func testFetchNotices_ReturnNoticeReponseDTO() {
        //Given
        let expectation = expectation(description: "fetch searched notices")
        
        //When
        dataSource.sendGetRequest(to: Bundle.main.searchURL + "?keyword=공지", resultType: NoticeReponseDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                //Then
                XCTAssertEqual($0.result.resultCode, 200)
                XCTAssertNotNil($0.body)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchNotices_ReturnNotices() {
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
