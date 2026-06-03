//
//  Container+Instance.swift
//  KNTip
//
//  Created by 이정훈 on 6/2/26.
//

import Factory
import KNDomain

extension Container {
    public var fetchTipUseCase: Factory<FetchTipUseCase> {
        Factory(self) {
            fatalError(
                "SearchNoticeAndBookmarkUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
}
