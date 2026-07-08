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
    
    public var fetchMajorCategoryUseCase: Factory<FetchSelectedMajorCategoryUseCase> {
        Factory(self) {
            fatalError(
                "FetchMajorCategoryUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
    
    public var fetchMajorCategoriesUseCase: Factory<FetchMajorCategoriesUseCase> {
        Factory(self) {
            fatalError(
                "FetchMajorCategoriesUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
    
    public var addMajorUseCase: Factory<AddMajorUseCase> {
        Factory(self) {
            fatalError(
                "AddMajorUseCase is not registered. Register it in App's dependency composition root."
            )
        }
        .singleton
    }
    
    public var deleteMajorUseCase: Factory<DeleteMajorUseCase> {
        Factory(self) {
            fatalError(
                "DeleteMajorUseCase is not registered. Register it in App's dependency composition root."
            )
        }
        .singleton
    }
}
