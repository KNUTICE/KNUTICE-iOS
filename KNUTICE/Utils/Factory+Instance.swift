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
    
    var localNotificationDataSource: Factory<LocalNotificationSubscriptionDataSource> {
        Factory(self) {
            LocalNotificationDataSourceImpl.shared
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
    
    var notificationRepository: Factory<NotificationSubscriptionRepository> {
        Factory(self) {
            NotificationSubscriptionRepositoryImpl()
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
    
    //MARK: - Service
    var reportService: Factory<ReportService> {
        Factory(self) {
            ReportServiceImpl()
        }
    }
    
    var notificationService: Factory<NotificationSubscriptionService> {
        Factory(self) {
            NotificationSubscriptionServiceImpl()
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
}
