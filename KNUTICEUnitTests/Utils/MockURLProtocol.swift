//
//  MockURLProtocol.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration)
    }()
    
    var activeTask: URLSessionTask?
    
    //파라미터로 전달된 Request를 처리할 수 있는지 여부
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    //표준 URLRequst를 반환
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    //캐싱 사용하지 않음
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        guard let mockData = createMockData() else {
            return
        }
        
        //요청에 대한 응답 객체를 생성했음을 알림
        client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .notAllowed)
        //Mock Data를 정상적으로 로드했음을 알림
        client?.urlProtocol(self, didLoad: mockData)
        //네트워크 요청이 완료되었음을 알림
        client?.urlProtocolDidFinishLoading(self)
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
    
    func createMockData() -> Data? {
        return nil
    }
}
