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
    
    private let noticeDataSource = NoticeDataSourceImpl()
    
    private init() {}
    
    func makeMainViewModel() -> MainViewModel {
        let dataSource = MainNoticeDataSourceImpl()
        let repository = MainNoticeRepositoryImpl(dataSource: dataSource)
        let viewModel = MainViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeGeneralNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.generalNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeAcademicNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.academicNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeScholarshipNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.scholarshipNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeEventNoticeViewModel() -> NoticeViewModel {
        let url = Bundle.main.eventNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    func makeSettingViewModel() -> SettingViewModel {
        return SettingViewModel()
    }
    
    func makeReportViewModel() -> ReportViewModel {
        //Data
        let tokenDataSource = TokenDataSourceImpl()
        let reportDataSource = ReportDataSourceImpl()
        let tokenRepository = TokenRepositoryImpl(dataSource: tokenDataSource)
        let reportRepository = ReportRepositoryImpl(dataSource: reportDataSource)
        
        //Domain
        let reportService = ReportServiceImpl(tokenRepository: tokenRepository, reportRepository: reportRepository)
        
        //Presentation
        let viewModel = ReportViewModel(reportService: reportService)
        
        return viewModel
    }
}
