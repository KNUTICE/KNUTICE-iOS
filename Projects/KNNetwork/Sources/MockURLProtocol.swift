//
//  MockURLProtocol.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Foundation

public final class MockURLProtocol: URLProtocol {
    private static let syncQueue = DispatchQueue(label: "MockURLProtocol.syncQueue")
    nonisolated(unsafe) private static var mockFileNames = [URL: String]()
    
    var activeTask: URLSessionTask?
    
    //파라미터로 전달된 Request를 처리할 수 있는지 여부
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    //표준 URLRequst를 반환
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    //캐싱 사용하지 않음
    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    public override func startLoading() {
        // URL 확인
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        
        // Mock 파일 이름 조회
        let mockFileName = Self.syncQueue.sync { Self.mockFileNames[url] }
        
        guard let fileName = mockFileName else {
            // 등록되지 않은 URL 요청인 경우 에러 처리
            client?.urlProtocol(self, didFailWithError: URLError(.fileDoesNotExist))
            return
        }
        
        // JSON 데이터 로드
        let bundle = Bundle(for: MockURLProtocol.self)
        
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            print("🚨 MockURLProtocol Error: JSON file named '\(fileName)' not found in bundle.")
            client?.urlProtocol(self, didFailWithError: URLError(.fileDoesNotExist))
            return
        }
        
        guard let mockData = try? Data(contentsOf: fileURL) else {
            print("🚨 MockURLProtocol Error: Unable to load data from '\(fileName)'.")
            client?.urlProtocol(self, didFailWithError: URLError(.cannotDecodeContentData))
            return
        }
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        
        //요청에 대한 응답 객체를 생성했음을 알림
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        //Mock Data를 정상적으로 로드했음을 알림
        client?.urlProtocol(self, didLoad: mockData)
        //네트워크 요청이 완료되었음을 알림
        client?.urlProtocolDidFinishLoading(self)
    }
    
    public override func stopLoading() {
        activeTask?.cancel()
    }
}

public extension MockURLProtocol {
    enum MockDataType {
        case fetchGeneralNoticesShouldSucceed
        case fetchAcademicNoticesShouldSucceed
        case fetchScholarshipNoticesShouldSucceed
        case fetchEventNoticesShouldSucceed
        case fetchEmploymentNoticesShouldSucceed
        case fetchSearchedNoticesShouldSucceed
        case fetchTopicSubscriptionsShouldSucceed
        case postRequestShouldSucceed
        case fetchSingleNoticeShouldSucceed
        case fetchTipsShouldSucceed
        case submitReportShouldSucceed
        
        var jsonFileName: String {
            switch self {
            case .fetchGeneralNoticesShouldSucceed:
                return "GeneralNotices"
                
            case .fetchAcademicNoticesShouldSucceed:
                return "AcademicNotices"
                
            case .fetchScholarshipNoticesShouldSucceed:
                return "ScholarshipNotices"
                
            case .fetchEventNoticesShouldSucceed:
                return "EventNotices"
                
            case .fetchEmploymentNoticesShouldSucceed:
                return "EmploymentNotices"
                
            case .fetchSearchedNoticesShouldSucceed:
                return "SearchedNotices"
                
            case .fetchTopicSubscriptionsShouldSucceed:
                return "TopicSubscriptionsStatus"
                
            case .postRequestShouldSucceed, .submitReportShouldSucceed:
                return "PostRequestSuccess"
                
            case .fetchSingleNoticeShouldSucceed:
                return "SingleNotice"
                
            case .fetchTipsShouldSucceed:
                return "Tips"
                
            }
        }
    }
    
    static func setUpMockData(_ type: MockDataType, for url: URL) {
        syncQueue.sync {
            mockFileNames[url] = type.jsonFileName
        }
    }
}
