//
//  Container+Instance.swift
//  KNNotice
//
//  Created by 이정훈 on 6/2/26.
//

import Factory
import KNDomain

extension Container {
    public var fetchNoticeSnapshotsUseCase: Factory<FetchNoticeSnapshotsUseCase> {
        Factory(self) {
            fatalError(
                "FetchNoticeSnapshotsUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
}
