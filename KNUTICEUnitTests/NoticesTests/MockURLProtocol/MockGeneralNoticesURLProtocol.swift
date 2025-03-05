//
//  GeneralNoticesMockURLProtocol.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 2/24/25.
//

import Foundation

final class MockGeneralNoticesURLProtocol: MockURLProtocol {
    override func createMockData() -> Data? {
        let fileName = "GeneralNotices"
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: fileURL)
    }
}
