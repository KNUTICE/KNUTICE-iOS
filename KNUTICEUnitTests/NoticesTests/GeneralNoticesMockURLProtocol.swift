//
//  GeneralNoticesMockURLProtocol.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Foundation

final class GeneralNoticesMockURLProtocol: MockURLProtocol {
    override func startLoading() {
        //Mock Data
        let mockData: Data? = createMockData()
        
        //요청에 대한 응답 개체를 생성했음을 알림
        client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .notAllowed)
        //테스트 Mock 데이터 내보내기
        client?.urlProtocol(self, didLoad: mockData!)
        //로드를 완료했음을 알림
        client?.urlProtocolDidFinishLoading(self)
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }
    
    private func createMockData() -> Data? {
        let fileName = "GeneralNotices"
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: fileURL)
    }
}
