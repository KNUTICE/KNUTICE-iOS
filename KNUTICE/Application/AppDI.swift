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
        let tokenDataSource = TokenDataSourceImpl()
        let tokenRepository = TokenRepositoryImpl(dataSource: tokenDataSource)
        let reportRepository = ReportRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        
        //Domain
        let reportService = ReportServiceImpl(tokenRepository: tokenRepository, reportRepository: reportRepository)
        
        //Presentation
        let viewModel = ReportViewModel(reportService: reportService)
        
        return viewModel
    }
    
    func makeDeveloperToolsViewModel() -> DeveloperToolsViewModel {
        let tokenDataSource = TokenDataSourceImpl()
        let tokenRepository = TokenRepositoryImpl(dataSource: tokenDataSource)
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
        let tokenDataSource = TokenDataSourceImpl()
        let localRepository = LocalNotificationPermissionRepositoryImpl(dataSource: localDataSource)
        let remoteRepository = RemoteNotificationPermissionRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
        let tokenRepository = TokenRepositoryImpl(dataSource: tokenDataSource)
        let notificationService = NotificationPermissionServiceImpl(tokenRepository: tokenRepository,
                                                                    localRepository: localRepository,
                                                                    remoteRepository: remoteRepository)
        let viewModel = NotificationListViewModel(repository: localRepository,
                                                  notificationService: notificationService)
        
        return viewModel
    }
}
