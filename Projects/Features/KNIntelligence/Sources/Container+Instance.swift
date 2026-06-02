//
//  Container+Instance.swift
//  KNIntelligence
//
//  Created by 이정훈 on 6/2/26.
//

import Factory
import KNDomain

extension Container {
    public var fetchNoticeSummaryUseCase: Factory<FetchNoticeSummaryUseCase> {
        Factory(self) {
            fatalError(
                "FetchNoticeSummaryUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
}
