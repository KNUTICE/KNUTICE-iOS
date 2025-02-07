//
//  AppDI.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Foundation

struct AppDI {
    static var shared: Self {
        return AppDI()
    }
    
    private init() {}

    func createSettingViewModel() -> SettingViewModel {
        return SettingViewModel()
    }
    
    func createReportViewModel() -> ReportViewModel {
        //Data
        let tokenRepository = TokenRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let reportRepository = ReportRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        
        //Domain
        let reportService = ReportServiceImpl(tokenRepository: tokenRepository, reportRepository: reportRepository)
        
        //Presentation
        let viewModel = ReportViewModel(reportService: reportService)
        
        return viewModel
    }
    
    func createDeveloperToolsViewModel() -> DeveloperToolsViewModel {
        let tokenRepository = TokenRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let viewModel = DeveloperToolsViewModel(tokenRepository: tokenRepository)
        
        return viewModel
    }
    
    func createSearchTableViewModel() -> SearchTableViewModel {
        let repository = SearchRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let viewModel = SearchTableViewModel(repository: repository)
        
        return viewModel
    }
    
    func createNotificationListViewModel() -> NotificationListViewModel {
        let localDataSource = NotificationPermissionDataSourceImpl.shared
        let localRepository = LocalNotificationPermissionRepositoryImpl(dataSource: localDataSource)
        let remoteRepository = RemoteNotificationPermissionRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let tokenRepository = TokenRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let notificationService = NotificationPermissionServiceImpl(tokenRepository: tokenRepository,
                                                                    localRepository: localRepository,
                                                                    remoteRepository: remoteRepository)
        let viewModel = NotificationListViewModel(repository: localRepository,
                                                  notificationService: notificationService)
        
        return viewModel
    }
    
    @MainActor
    func createBookmarkListViewModel() -> BookmarkListViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let viewModel = BookmarkListViewModel(repository: repository)
        
        return viewModel
    }
    
    func createBookmarkFormViewModel() -> BookmarkFormViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let service = BookmarkServiceImpl(repository: repository)
        let viewModel = BookmarkFormViewModel(service: service)
        
        return viewModel
    }
    
    func createBookmarkDetailViewModel() -> BookmarkDetailViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let service = BookmarkServiceImpl(repository: repository)
        let viewModel = BookmarkDetailViewModel(bookmarkService: service)
        
        return viewModel
    }
    
    func createBookmarkEditFormViewModel(from bookmark: Bookmark) -> BookmarkEditFormViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let service = BookmarkServiceImpl(repository: repository)
        let viewModel = BookmarkEditFormViewModel(bookmark: bookmark, bookmarkService: service)
        
        return viewModel
    }
    
    func createTabBarViewModel() -> TabBarViewModel {
        let dataSource = RemoteDataSourceImpl.shared
        let repository = MainPopupContentRepositoryImpl(dataSource: dataSource)
        let viewModel = TabBarViewModel(repsotiroy: repository)
        
        return viewModel
    }
}
