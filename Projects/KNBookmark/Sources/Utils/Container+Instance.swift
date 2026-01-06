//
//  Container+Instance.swift
//  KNBookmark
//
//  Created by 이정훈 on 1/4/26.
//

import Factory

extension Container {
    var bookmarkDataSource: Factory<BookmarkPersistenceStore> {
        Factory(self) {
            BookmarkPersistenceStoreImpl.shared
        }
    }
    
    var bookmarkRepository: Factory<BookmarkRepository> {
        Factory(self) {
            BookmarkRepositoryImpl.shared
        }
    }
}

public extension Container {
    var saveBookmarkUseCase: Factory<SaveBookmarkUseCase> {
        Factory(self) {
            SaveBookmarkUseCaseImpl()
        }
    }
    
    var deleteBookmarkUseCase: Factory<DeleteBookmarkUseCase> {
        Factory(self) {
            DeleteBookmarkUseCaseImpl()
        }
    }
    
    var updateBookmarkUseCase: Factory<UpdateBookmarkUseCase> {
        Factory(self) {
            UpdateBookmarkUseCaseImpl()
        }
    }
    
    var fetchBookmarksUseCase: Factory<FetchBookmarksUseCase> {
        Factory(self) {
            FetchBookmarksUseCaseImpl()
        }
    }
    
    var provideReloadEventPublisherUseCase: Factory<ProvideReloadEventPublisherUseCase> {
        Factory(self) {
            ProvideReloadEventPublisherUseCaseImpl()
        }
    }
    
    var searchNoticeAndBookmarkUseCase: Factory<SearchNoticeAndBookmarkUseCase> {
        Factory(self) {
            SearchNoticeAndBookmarkUseCaseImpl()
        }
    }
}

extension Container {
    var searchBookmarksUseCase: Factory<SearchBookmarksUseCase> {
        Factory(self) {
            SearchBookmarksUseCaseImpl()
        }
    }
}
