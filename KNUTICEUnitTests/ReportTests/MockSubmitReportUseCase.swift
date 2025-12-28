//
//  MockSubmitReportUseCase.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/15/25.
//

import Foundation
@testable import KNUTICE

enum MockSubmitReportError: Error {
    case submitFailed
}

actor MockSubmitReportUseCaseSuccess: SubmitReportUseCase {
    func execute(content: String, device: String) async throws {}
    
}

actor MockSubmitReportUseCaseFailure: SubmitReportUseCase {
    func execute(content: String, device: String) async throws {
        throw MockSubmitReportError.submitFailed
    }
    
}
