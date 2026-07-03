//
//  Container+Instance.swift
//  KNBookmark
//
//  Created by 이정훈 on 1/4/26.
//

import Factory
import KNDomain
import KNNetwork
import KNUtility

extension Container {
    public var searchNoticesUseCase: Factory<SearchNoticeSnapshotsUseCase> {
        Factory(self) { fatalError("SearchNoticesUseCase has not been registered.") }
    }
    
    public var searchBookmarksUseCase: Factory<SearchBookmarksUseCase> {
        Factory(self) { fatalError("SearchBookmarksUseCase has not been registered.") }
    }
    
    @MainActor
    var searchViewModel: Factory<SearchViewModel> {
        .mainActor(self) { SearchViewModel() }
    }
}
