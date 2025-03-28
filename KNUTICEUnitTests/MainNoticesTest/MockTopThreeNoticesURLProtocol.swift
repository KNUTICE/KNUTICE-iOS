//
//  TopThreeNoticesMockURLProtocol.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Foundation

final class MockTopThreeNoticesURLProtocol: MockURLProtocol {
    override func createMockData() -> Data? {
        let fileName: String = "TopThreeNotices"
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: fileURL)
    }
}
