//
//  Container+Instance.swift
//  KNDeepLink
//
//  Created by 이정훈 on 1/6/26.
//

import Factory

public extension Container {
    var fetchStoredDeepLinkUseCase: Factory<FetchStoredDeepLinkUseCase> {
        Factory(self) {
            FetchStoredDeepLinkUseCaseImpl()
        }
    }
}
