//
//  Container+Instance.swift
//  KNNotice
//
//  Created by 이정훈 on 6/2/26.
//

import Factory
import KNDomain

extension Container {
    public var fetchNoticesUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) {
            fatalError(
                "FetchNoticesUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
}
