//
//  DependencyValues+Live.swift
//  KNReport
//
//  Created by 이정훈 on 1/16/26.
//

import ComposableArchitecture

extension DependencyValues {
    var submitReportUseCase: SubmitReportUseCase {
        get { self[SubmitReportUseCaseKey.self] }
        set { self[SubmitReportUseCaseKey.self] = newValue }
    }
}

fileprivate enum SubmitReportUseCaseKey: DependencyKey {
    static let liveValue: SubmitReportUseCase = SubmitReportUseCaseImpl()
}
