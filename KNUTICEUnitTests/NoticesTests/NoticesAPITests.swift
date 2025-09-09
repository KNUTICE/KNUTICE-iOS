//
//  NoticesAPITests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Alamofire
import Combine
import Factory
import XCTest
import KNUTICECore
@testable import KNUTICE

final class NoticesAPITests: XCTestCase {
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

    func test_fetchGeneralNotices_returnNoticesDTO() {
        // Given
        guard let baseURL = Bundle.main.noticeURL else {
            XCTFail("❌ Failed to load noticeURL from Bundle.main. Check ServiceInfo.plist or Bundle extension.")
            return
        }
        
        let endpoint = baseURL + "?noticeName=\(NoticeCategory.generalNotice.rawValue)"
        let expectation = XCTestExpectation(description: "Should fetch general notices successfully")
        
        MockURLProtocol.setUpMockData(
            .fetchGeneralNoticesShouldSucceed,
            for: URL(string: endpoint)!
        )
        
        // When
        dataSource.request(
            endpoint,
            method: .get,
            decoding: NoticeResponseDTO.self
        )
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("❌ Request failed with error: \(error)")
            }
        }, receiveValue: { response in
            // Then
            XCTAssertEqual(response.code, 200, "✅ Response code should be 200")
            XCTAssertEqual(response.data?.count, 20, "✅ Should return 20 notices")
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchAcademicNotices_returnNoticesDTO() {
        //Given
        guard let baseURL = Bundle.main.noticeURL else {
            XCTFail("Failed to load noticeURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        let expectation = XCTestExpectation(description: "fetch academic notices")
        let endpoint = baseURL + "?noticeName=\(NoticeCategory.academicNotice.rawValue)"
        
        MockURLProtocol.setUpMockData(
            .fetchAcademicNoticesShouldSucceed,
            for: URL(string: endpoint)!
        )
        
        //When
        dataSource.request(
            endpoint,
            method: .get,
            decoding: NoticeResponseDTO.self
        )
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
            }
        }, receiveValue: {
            XCTAssertEqual($0.data?.count, 20)
            XCTAssertEqual($0.code, 200)
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchScholarshipNotices_returnNoticesDTO() {
        //Given
        guard let baseURL = Bundle.main.noticeURL else {
            XCTFail("Failed to load noticeURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }

        
        let expectation = XCTestExpectation(description: "fetch scholarship notices")
        let endpoint = baseURL + "?noticeName=\(NoticeCategory.scholarshipNotice.rawValue)"
        
        MockURLProtocol.setUpMockData(
            .fetchScholarshipNoticesShouldSucceed,
            for: URL(string: endpoint)!
        )
        
        //When
        dataSource.request(
            endpoint,
            method: .get,
            decoding: NoticeResponseDTO.self
        )
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
            }
        }, receiveValue: {
            XCTAssertEqual($0.data?.count, 20)
            XCTAssertEqual($0.code, 200)
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchEventNotices_returnNoticesDTO() {
        //Given
        guard let baseURL = Bundle.main.noticeURL else {
            XCTFail("Failed to load noticeURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        let expectation = XCTestExpectation(description: "fetch event notices")
        let endpoint = baseURL + "?noticeName=\(NoticeCategory.eventNotice.rawValue)"
        
        MockURLProtocol.setUpMockData(
            .fetchEventNoticesShouldSucceed,
            for: URL(string: endpoint)!
        )
        
        //When
        dataSource.request(
            endpoint,
            method: .get,
            decoding: NoticeResponseDTO.self
        )
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
            }
        }, receiveValue: {
            XCTAssertEqual($0.data?.count, 20)
            XCTAssertEqual($0.code, 200)
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchEmploymentNotices_returnNoticesDTO() {
        guard let baseURL = Bundle.main.noticeURL else {
            XCTFail("Failed to load noticeURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }

        
        let expectation = XCTestExpectation(description: "fetch event notices")
        let endpoint = baseURL + "?noticeName=\(NoticeCategory.employmentNotice.rawValue)"
        
        MockURLProtocol.setUpMockData(
            .fetchEmploymentNoticesShouldSucceed,
            for: URL(string: endpoint)!
        )
        
        //When
        dataSource.request(
            endpoint,
            method: .get,
            decoding: NoticeResponseDTO.self
        )
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
            }
        }, receiveValue: {
            XCTAssertEqual($0.data?.count, 20)
            XCTAssertEqual($0.code, 200)
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchSingleNotice_returnNoticeDTO() async throws {
        guard let baseURL = Bundle.main.noticeURL else {
            XCTFail("Failed to load noticeURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension.")
            return
        }
        
        let expectation = XCTestExpectation(description: "fetch single notice")
        let endpoint = baseURL + "/1079970"
        
        MockURLProtocol.setUpMockData(
            .fetchSingleNoticeShouldSucceed,
            for: URL(string: endpoint)!
        )
        
        let dto = try await dataSource.request(
            endpoint,
            method: .get,
            decoding: SingleNoticeResponseDTO.self
        )
        
        XCTAssertEqual(dto.data?.nttID, 1079970)
        
        expectation.fulfill()
    }
}
