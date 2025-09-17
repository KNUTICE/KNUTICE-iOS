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
    
    var reportService: Factory<ReportService> {
        Factory(self) {
            ReportServiceImpl()
        }
    }
    
    var bookmarkService: Factory<BookmarkService> {
        Factory(self) {
            BookmarkServiceImpl()
        }
    }
    
    var tabBarService: Factory<TabBarService> {
        Factory(self) {
            TabBarServiceImpl()
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
    
    var searchCollectionViewModel: Factory<NoticeSectionModelProvidable> {
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
