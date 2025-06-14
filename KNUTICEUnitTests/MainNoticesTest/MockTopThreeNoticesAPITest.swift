import Alamofire
import Combine
import Factory
import XCTest
@testable import KNUTICE

final class MockTopThreeNoticesAPITests: XCTestCase {
    private var dataSource: RemoteDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        Container.shared.remoteDataSource.register {
            RemoteDataSourceImpl(session: session)
        }
        dataSource = Container.shared.remoteDataSource()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        cancellables = nil
    }
    
    func test_fetchTopThreeNotices_returnsMainNoticeResponseDTO() {
        let expectation = XCTestExpectation(description: "Wait for fetch top three notices")
        MockURLProtocol.setUpMockData(.fetchTopThreeNoticesShouldSucceed)
        
        dataSource.request(Bundle.main.mainNoticeURL, method: .get, decoding: MainNoticeResponseDTO.self)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("\(error)")
                }
            } receiveValue: { dto in
                XCTAssertEqual(dto.result.resultCode, 200)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
