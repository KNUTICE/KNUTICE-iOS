//
//  Factory+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/7/25.
//

import Factory
import Foundation

extension Container {
    //MARK: - RemoteDataSource
    var remoteDataSource: Factory<RemoteDataSource> {
        Factory(self) {
            RemoteDataSourceImpl()
        }
    }
    
    var localBookmarkDataSource: Factory<LocalBookmarkDataSource> {
        Factory(self) {
            LocalBookmarkDataSourceImpl.shared
        }
    }
    
    //MARK: - Repositroy
    var mainNoticeRepository: Factory<MainNoticeRepository> {
        Factory(self) {
            MainNoticeRepositoryImpl()
        }
    }
    
    var noticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl()
        }
    }
    
    var tokenRepository: Factory<TokenRepository> {
        Factory(self) {
            TokenRepositoryImpl()
        }
    }
    
    var reportRepository: Factory<ReportRepository> {
        Factory(self) {
            ReportRepositoryImpl()
        }
    }
    
    var searchRepository: Factory<SearchRepository> {
        Factory(self) {
            SearchRepositoryImpl()
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
    
    var mainPopupContentRepository: Factory<MainPopupContentRepository> {
        Factory(self) {
            MainPopupContentRepositoryImpl()
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
    
    var subscriptionService: Factory<TopicSubscriptionService> {
        Factory(self) {
            TopicSubscriptionServiceImpl()
        }
    }
    
    //MARK: - ViewModel
    var mainViewModel: Factory<MainTableViewModel> {
        Factory(self) {
            MainTableViewModel()
        }
    }
    
    var reportViewModel: Factory<ReportViewModel> {
        Factory(self) {
            ReportViewModel()
        }
    }
    
    var searchCollectionViewModel: Factory<NoticeSectionModelProvidable> {
        Factory(self) {
            SearchCollectionViewModel()
        }
    }
    
    var bookmarkTableViewModel: Factory<BookmarkTableViewModel> {
        Factory(self) {
            BookmarkTableViewModel()
        }
    }
}
