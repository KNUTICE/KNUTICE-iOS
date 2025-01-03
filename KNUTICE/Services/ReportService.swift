//
//  ReportService.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine

protocol ReportService {
    func report(content: String, device: String) -> AnyPublisher<Bool, any Error>
}

final class ReportServiceImpl<T: TokenRepository, R: ReportRepository>: ReportService, AppVersionProvidable {
    let tokenRepository: T
    let reportRepository: R
    
    init(tokenRepository: T, reportRepository: R) {
        self.tokenRepository = tokenRepository
        self.reportRepository = reportRepository
    }
    
    func report(content: String, device: String) -> AnyPublisher<Bool, any Error> {
        return tokenRepository.getFCMToken()
            .flatMap { token -> AnyPublisher<Bool, any Error> in
                let params = [
                    "result": [
                        "resultCode": 0,
                        "resultMessage": "string",
                        "resultDescription": "string"
                    ],
                    "body": [
                        "token": token,
                        "content": content,
                        "clientType": "APP",
                        "deviceName": device,
                        "version": self.getAppVersion()
                    ]
                ] as [String : Any]
                
                return self.reportRepository.register(params: params)
            }
            .eraseToAnyPublisher()
    }
}
