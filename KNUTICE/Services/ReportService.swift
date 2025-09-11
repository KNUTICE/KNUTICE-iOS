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
                
                return self.reportRepository.register(
                    params: [
                        "content": content,
                        "deviceName": device,
                        "version": self.getAppVersion()
                    ]
                )
            }
            .eraseToAnyPublisher()
    }
}
