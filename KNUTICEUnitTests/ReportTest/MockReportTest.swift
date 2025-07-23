//
//  ReportMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import Combine
import XCTest
@testable import KNUTICE

final class MockReportTest: XCTestCase {
    private var viewModel: ReportViewModel!
    private var cancellables: Set<AnyCancellable>!
    private var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Given: ViewModel과 필수 설정 준비
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = ReportViewModel()
        viewModel.content = "문의사항입니다."
        cancellables = []
        expectation = XCTestExpectation(description: "Report transmission succeeds")
        MockURLProtocol.setUpMockData(.postRequestShouldSucceed)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        viewModel = nil
        cancellables = nil
        expectation = nil
    }
    
    func test_givenContent_whenReportSubmitted_thenReceivesSuccessResponse() {
        viewModel.$isShowingAlert
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                //Then
                XCTAssertEqual(self?.viewModel.alertType, .success)
                self?.expectation.fulfill()
            })
            .store(in: &cancellables)
        
        //When
        viewModel.report(device: "iPhone 15")
        
        wait(for: [expectation], timeout: 1)
    }

}
