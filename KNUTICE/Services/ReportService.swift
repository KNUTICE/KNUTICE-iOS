//
//  ReportService.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine
import Factory
import Foundation
import KNUTICECore

protocol ReportService {
    func report(content: String, device: String) -> AnyPublisher<Bool, any Error>
}

final class ReportServiceImpl: ReportService, AppVersionProvidable {
    @Injected(\.reportRepository) private var reportRepository: ReportRepository
    
    func report(content: String, device: String) -> AnyPublisher<Bool, any Error> {
        return FCMTokenManager.shared.getToken()
            .flatMap { [weak self] token -> AnyPublisher<Bool, any Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SelfDeallocated", code: -1))
                        .eraseToAnyPublisher()
                }
                
                let params = self.createParams(content: content, device: device, token: token)
                return self.reportRepository.register(params: params)
            }
            .eraseToAnyPublisher()
    }
    
    private func createParams(content: String, device: String, token: String) -> [String: any Sendable] {
        let params = [
            "result": commonResultInfo,
            "body": [
                "fcmToken": token,
                "content": content,
                "clientType": "APP",
                "deviceName": device,
                "version": self.getAppVersion()
            ]
        ]
        
        return params
    }
}
