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
    
    func makeMainViewModel() -> MainViewModel {
        let repository = MainNoticeRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let viewModel = MainViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeGeneralNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.generalNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl.shared, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeAcademicNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.academicNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl.shared, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeScholarshipNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.scholarshipNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl.shared, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeEventNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.eventNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl.shared, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeSettingViewModel() -> SettingViewModel {
        return SettingViewModel()
    }
    
    func makeReportViewModel() -> ReportViewModel {
        //Data
        let tokenRepository = TokenRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let reportRepository = ReportRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        
        //Domain
        let reportService = ReportServiceImpl(tokenRepository: tokenRepository, reportRepository: reportRepository)
        
        //Presentation
        let viewModel = ReportViewModel(reportService: reportService)
        
        return viewModel
    }
    
    func makeDeveloperToolsViewModel() -> DeveloperToolsViewModel {
        let tokenRepository = TokenRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let viewModel = DeveloperToolsViewModel(tokenRepository: tokenRepository)
        
        return viewModel
    }
    
    func makeSearchTableViewModel() -> SearchTableViewModel {
        let repository = SearchRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let viewModel = SearchTableViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeNotificationListViewModel() -> NotificationListViewModel {
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
    func makeBookmarkListViewModel() -> BookmarkListViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let viewModel = BookmarkListViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeBookmarkFormViewModel() -> BookmarkFormViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let service = BookmarkServiceImpl(repository: repository)
        let viewModel = BookmarkFormViewModel(service: service)
        
        return viewModel
    }
    
    func makeBookmarkDetailViewModel() -> BookmarkDetailViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let viewModel = BookmarkDetailViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeBookmarkEditFormViewModel(from bookmark: Bookmark) -> BookmarkEditFormViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl(dataSource: dataSource)
        let viewModel = BookmarkEditFormViewModel(bookmark: bookmark, repository: repository)
        
        return viewModel
    }
}
