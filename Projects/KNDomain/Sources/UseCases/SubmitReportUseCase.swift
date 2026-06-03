//
//  SubmitReportUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/14/25.
//

import Combine
import KNUtility

public protocol SubmitReportUseCase: Actor {
    func execute(content: String, device: String) async throws
}

public actor SubmitReportUseCaseImpl: SubmitReportUseCase, AppVersionProvidable {
    private let repository: ReportRepository
    
    public init(repository: ReportRepository) {
        self.repository = repository
    }
    
    public func execute(content: String, device: String) async throws {
        let params: [String: any Sendable] = [
            "content": content,
            "deviceName": device,
            "version": getAppVersion()
        ]
        
        try await repository.register(params: params)
    }
    
    
}
