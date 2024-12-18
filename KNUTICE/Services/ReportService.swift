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

final class ReportServiceImpl: ReportService, AppVersionProvidable {
    let tokenRepository: TokenRepository
    let reportRepository: ReportRepository
    
    init(tokenRepository: TokenRepository, reportRepository: ReportRepository) {
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
