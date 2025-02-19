//
//  MainPopupTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 1/24/25.
//

import XCTest
import Combine
import Factory
@testable import KNUTICE

final class MainPopupTests: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = Container.shared.remoteDataSource()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        dataSource = nil
        cancellables = nil
    }
    
    func testNetworkRequest() {
        //Given
        let expectation = XCTestExpectation(description: "network request test")
        let apiEndPoint = Bundle.main.mainPopupContentURL
        
        //When
        dataSource.sendGetRequest(to: apiEndPoint, resultType: MainPopupContentDTO.self)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                //Then
                XCTAssert($0.result.resultCode == 200 || $0.result.resultCode == 4000)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}
