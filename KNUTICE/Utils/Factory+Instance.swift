//
//  Factory+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/7/25.
//

import Factory
import Foundation
import KNUTICECore

extension Container {
    var bookmarkDataSource: Factory<BookmarkPersistenceStore> {
        Factory(self) {
            BookmarkPersistenceStoreImpl.shared
        }
    }
    
    //MARK: - Repositroy
    
    var reportRepository: Factory<ReportRepository> {
        Factory(self) {
            ReportRepositoryImpl()
        }
    }
    
    var topicSubscriptionRepository: Factory<TopicSubscriptionRepository> {
        Factory(self) {
            TopicSubscriptionRepositoryImpl()
        }
    }
    
    var bookmarkRepository: Factory<BookmarkRepository> {
        Factory(self) {
            BookmarkRepositoryImpl.shared
        }
    }
    
    var TipRepository: Factory<TipRepository> {
        Factory(self) {
            TipRepositoryImpl()
        }
    }
    
    //MARK: - UseCases
    
    var fetchNoticeUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) {
            FetchNoticesUseCaseImpl()
        }
    }
    
    var fetchTopThreeNoticesUseCase: Factory<FetchTopThreeNoticesUseCase> {
        Factory(self) {
            FetchTopThreeNoticesUseCaseImpl(repository: Container.shared.noticeRepository())
        }
    }
    
    var searchNoticesUseCase: Factory<SearchNoticesUseCase> {
        Factory(self) {
            SearchNoticesUseCaseImpl()
        }
    }
    
    var searchBookmarksUseCase: Factory<SearchBookmarksUseCase> {
        Factory(self) {
            SearchBookmarksUseCaseImpl()
        }
    }
    
    var searchNoticeAndBookmarkUseCase: Factory<SearchNoticeAndBookmarkUseCase> {
        Factory(self) {
            SearchNoticeAndBookmarkUseCaseImpl()
        }
    }
    
    var registerFCMTokenUseCase: Factory<RegisterFCMTokenUseCase> {
        Factory(self) {
            RegisterFCMTokenUseCaseImpl()
        }
    }
    
    var fetchStoredDeepLinkUseCase: Factory<FetchStoredDeepLinkUseCase> {
        Factory(self) {
            FetchStoredDeepLinkUseCaseImpl()
        }
    }
    
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
    
    var refreshBookmarkAfterDeletionUseCase: Factory<RefreshBookmarkAfterDeletionUseCase> {
        Factory(self) {
            RefreshBookmarkAfterDeletionUseCaseImpl()
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
    
    //MARK: - ViewModel
    var mainViewModel: Factory<MainTableViewModel> {
        Factory(self) { @MainActor in
            MainTableViewModel()
        }
    }
    
    var reportViewModel: Factory<ReportViewModel> {
        Factory(self) {
            ReportViewModel()
        }
    }
    
    var searchCollectionViewModel: Factory<SearchViewModel> {
        Factory(self) { @MainActor in
            SearchViewModel()
        }
    }
    
    var bookmarkTableViewModel: Factory<BookmarkTableViewModel> {
        Factory(self) { @MainActor in
            BookmarkTableViewModel()
        }
    }
    
    var parentViewModel: Factory<ParentViewModel> {
        Factory(self) { @MainActor in
            ParentViewModel()
        }
    }
}
