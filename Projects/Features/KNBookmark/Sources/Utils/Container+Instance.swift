//
//  Container+Instance.swift
//  KNBookmark
//
//  Created by 이정훈 on 6/2/26.
//

import Factory
import KNDomain

extension Container {
    public var fetchBookmarkUseCase: Factory<FetchBookmarksUseCase> {
        Factory(self) {
            fatalError("FetchBookmarksUseCase is not registered. Register it in App's dependency composition root.")
        }
    }
    
    public var provideReloadEventPublisherUseCase: Factory<ProvideReloadEventPublisherUseCase> {
        Factory(self) {
            fatalError("ProvideReloadEventPublisherUseCase is not registered. Register it in App's dependency composition root.")
        }
    }
    
    public var deleteBookmarkUseCase: Factory<DeleteBookmarkUseCase> {
        Factory(self) {
            fatalError("DeleteBookmarkUseCase is not registered. Register it in App's dependency composition root.")
        }
    }
}
