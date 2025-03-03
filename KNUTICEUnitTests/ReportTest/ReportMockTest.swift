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

final class ReportMockTest: XCTestCase {
    private var viewModel: ReportViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockPostAPIURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        viewModel = ReportViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        cancellables = nil
    }
    
    func test_문의사항_입력후_제출버튼을_누르면_성공응답을_받음() {
        //Given
        let expectation = expectation(description: "Report transmission success")
        viewModel.content = "문의사항입니다."
        viewModel.$isShowingAlert
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                //Then
                XCTAssertEqual(self?.viewModel.alertType, .success)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        //When
        viewModel.report(device: "iPhone 15")
        
        wait(for: [expectation], timeout: 1)
    }

}
