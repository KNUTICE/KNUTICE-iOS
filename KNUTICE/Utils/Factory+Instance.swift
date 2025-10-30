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
            BookmarkRepositoryImpl()
        }
    }
    
    var TipRepository: Factory<TipRepository> {
        Factory(self) {
            TipRepositoryImpl()
        }
    }
    
    //MARK: - Service
    
    var bookmarkService: Factory<BookmarkService> {
        Factory(self) {
            BookmarkServiceImpl()
        }
    }
    
    var pushNoticeService: Factory<DeepLinkService> {
        Factory(self) {
            DeepLinkServiceImpl()
        }
    }
    
    var searchService: Factory<SearchService> {
        Factory(self) {
            SearchServiceImpl()
        }
    }
    
    var fcmTokenService: Factory<FCMTokenService> {
        Factory(self) {
            FCMTokenServiceImpl()
        }
    }
    
    var noticeService: Factory<NoticeService> {
        Factory(self) {
            NoticeServiceImpl()
        }
    }
    
    var fetchNoticeUseCase: Factory<FetchNoticeUseCase> {
        Factory(self) {
            FetchNoticeUseCaseImpl()
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
