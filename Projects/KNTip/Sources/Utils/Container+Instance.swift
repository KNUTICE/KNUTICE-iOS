//
//  Container+Instance.swift
//  KNTip
//
//  Created by 이정훈 on 1/6/26.
//

import Factory

extension Container {
    var tipRepository: Factory<TipRepository> {
            Factory(self) {
                TipRepositoryImpl()
            }
        }
}

public extension Container {
    var fetchTipUseCase: Factory<FetchTipUseCase> {
        Factory(self) {
            FetchTipUseCaseImpl()
        }
    }
}
