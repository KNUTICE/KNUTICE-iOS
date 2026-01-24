//
//  Container+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/26.
//

import Factory
import KNTip
import KNNotice

extension Container {
    var fetchTipUseCase: Factory<FetchTipUseCase> {
        Factory(self) {
            FetchTipUseCaseImpl()
        }
    }

    @MainActor
    var parentViewModel: Factory<ParentViewModel> {
        .mainActor(self) { ParentViewModel() }
    }
}
