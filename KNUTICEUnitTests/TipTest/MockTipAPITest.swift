//
//  MockTipAPITest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 7/10/25.
//

import Alamofire
import Combine
import Factory
import XCTest
@testable import KNUTICE

@MainActor
final class MockTipAPITest: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var viewModel: TipBannerViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        viewModel = TipBannerViewModel()
        cancellables = []
        MockURLProtocol.setUpMockData(.fetchTipsShouldSucceed)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
    }
    
    func test_fetchTipData_returnsTipDTO() async throws {
        //When
        let dto = try await dataSource.request(
            Bundle.main.tipURL,
            method: .get,
            decoding: TipDTO.self
        )
        
        //Then
        XCTAssertEqual(dto.body?.count, 2)
    }
    
    func test_tipBannerViewModel_returnsTips() {
        //Given
        let expectation = XCTestExpectation(description: "Successfully fetches Tips")
        
        viewModel.$tips
            .dropFirst()
            .sink(receiveValue: {
                //Then
                XCTAssertEqual($0?.count, 2)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        //When
        Task {
            await viewModel.fetchTips()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
