//
//  Container+Instance.swift
//  KNBookmark
//
//  Created by 이정훈 on 1/4/26.
//

import Factory
import KNData
import KNDomain
import KNNetwork
import KNUtility

extension Container {
    
    // MARK: - Data Sources
    var bookmarkDataSource: Factory<BookmarkPersistenceStore> {
        Factory(self) {
            BookmarkPersistenceStoreImpl.shared
        }
    }
    
    // MARK: - Repositories
    var bookmarkRepository: Factory<BookmarkRepository> {
        Factory(self) {
            BookmarkRepositoryImpl.shared
        }
    }
    
    // MARK: - UseCases
    public var fetchNoticesUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) {
            FetchNoticesUseCaseImpl(noticeRepository: self.noticeRepository())
        }
    }
    
    public var fetchTopThreeNoticesUseCase: Factory<FetchTopThreeNoticesUseCase> {
        Factory(self) { FetchTopThreeNoticesUseCaseImpl(repository: self.noticeRepository()) }
    }
    
    // [Bookmark Related]
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
    
    var searchBookmarksUseCase: Factory<SearchBookmarksUseCase> {
        Factory(self) {
            SearchBookmarksUseCaseImpl()
        }
    }
    
    // [Notice Related]
    var searchNoticesUseCase: Factory<SearchNoticesUseCase> {
        Factory(self) {
            SearchNoticesUseCaseImpl(noticeRepository: NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl()))
        }
    }
    
    // [Composite / Utility]
    var searchNoticeAndBookmarkUseCase: Factory<SearchNoticeAndBookmarkUseCase> {
        Factory(self) {
            SearchNoticeAndBookmarkUseCaseImpl()
        }
    }
    
    var provideReloadEventPublisherUseCase: Factory<ProvideReloadEventPublisherUseCase> {
        Factory(self) {
            ProvideReloadEventPublisherUseCaseImpl()
        }
    }
    
    // MARK: - ViewModels
    @MainActor
    var bookmarkTableViewModel: Factory<BookmarkTableViewModel> {
        .mainActor(self) { BookmarkTableViewModel() }
    }
    
    @MainActor
    var searchViewModel: Factory<SearchViewModel> {
        .mainActor(self) { SearchViewModel() }
    }
}
