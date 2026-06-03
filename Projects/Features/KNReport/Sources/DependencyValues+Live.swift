//
//  DependencyValues+Live.swift
//  KNReport
//
//  Created by 이정훈 on 1/16/26.
//

import ComposableArchitecture
import KNDomain

extension DependencyValues {
    public var submitReportUseCase: SubmitReportUseCase {
        get { self[SubmitReportUseCaseKey.self] }
        set { self[SubmitReportUseCaseKey.self] = newValue }
    }
}

enum SubmitReportUseCaseKey: DependencyKey {
    static var liveValue: SubmitReportUseCase {
        fatalError("Must override from App")
    }
}
