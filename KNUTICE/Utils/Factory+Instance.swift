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
            RemoteDataSourceImpl.shared
        }
    }
    
    var localNotificationDataSource: Factory<LocalNotificationDataSource> {
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
    
    var generalNoticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl(remoteURL: Bundle.main.generalNoticeURL)
        }
    }
    
    var academicNoticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl(remoteURL: Bundle.main.academicNoticeURL)
        }
    }
    
    var scholarshipNoticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl(remoteURL: Bundle.main.scholarshipNoticeURL)
        }
    }
    
    var eventNoticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl(remoteURL: Bundle.main.eventNoticeURL)
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
    
    var localNotificationRepository: Factory<LocalNotificationRepository> {
        Factory(self) {
            LocalNotificationRepositoryImpl()
        }
    }
    
    var remoteNotificationRepository: Factory<RemoteNotificationRepository> {
        Factory(self) {
            RemoteNotificationRepositoryImpl()
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
    
    var notificationService: Factory<NotificationService> {
        Factory(self) {
            NotificationServiceImpl()
        }
    }
    
    var bookmarkService: Factory<BookmarkService> {
        Factory(self) {
            BookmarkServiceImpl()
        }
    }
    
    //MARK: - ViewModel
    var mainViewModel: Factory<MainViewModel> {
        Factory(self) {
            MainViewModel()
        }
    }
    
    var generalNoticeTableViewModel: Factory<NoticeTableViewModel> {
        Factory(self) {
            NoticeTableViewModel(repository: self.generalNoticeRepository())
        }
    }
    
    var academicNoticeTableViewModel: Factory<NoticeTableViewModel> {
        Factory(self) {
            NoticeTableViewModel(repository: self.academicNoticeRepository())
        }
    }
    
    var scholarshipNoticeTableViewModel: Factory<NoticeTableViewModel> {
        Factory(self) {
            NoticeTableViewModel(repository: self.scholarshipNoticeRepository())
        }
    }
    
    var eventNoticeTableViewModel: Factory<NoticeTableViewModel> {
        Factory(self) {
            NoticeTableViewModel(repository: self.eventNoticeRepository())
        }
    }
    
    var reportViewModel: Factory<ReportViewModel> {
        Factory(self) {
            ReportViewModel()
        }
    }
}
