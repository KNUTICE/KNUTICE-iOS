//
//  SubmitReportUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/14/25.
//

import Combine
import Factory

protocol SubmitReportUseCase: Actor {
    func execute(content: String, device: String) async throws
}

actor SubmitReportUseCaseImpl: SubmitReportUseCase, AppVersionProvidable {
    @Injected(\.reportRepository) private var repository
    
    func execute(content: String, device: String) async throws {
        let params: [String: any Sendable] = [
            "content": content,
            "deviceName": device,
            "version": getAppVersion()
        ]
        
        try await repository.register(params: params)
    }
    
    
}
