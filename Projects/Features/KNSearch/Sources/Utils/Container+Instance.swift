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
    public var searchNoticeAndBookmarkUseCase: Factory<SearchNoticeAndBookmarkUseCase> {
        Factory(self) {
            fatalError(
                "SearchNoticeAndBookmarkUseCase is not registered. Register it in App's dependency composition root."
            )
        }
    }
    
    @MainActor
    var searchViewModel: Factory<SearchViewModel> {
        .mainActor(self) { SearchViewModel() }
    }
}
