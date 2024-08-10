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
    
    let noticeDataSource = NoticeDataSourceImpl()
    
    var mainViewModel: MainViewModel {
        let dataSource = MainNoticeDataSourceImpl()
        let repository = MainNoticeRepositoryImpl(dataSource: dataSource)
        let viewModel = MainViewModel(repository: repository)
        
        return viewModel
    }
    
    var generalNoticeViewModel: NoticeViewModel {
        let url = Bundle.main.generalNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    var academicNoticewViewModel: NoticeViewModel {
        let url = Bundle.main.academicNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    var scholarshipNoticeViewModel: NoticeViewModel {
        let url = Bundle.main.scholarshipNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    var eventNoticeViewModel: NoticeViewModel {
        let url = Bundle.main.eventNoticeURL
        let repository = NoticeRepositoryImpl(dataSource: noticeDataSource, remoteURL: url)
        let viewModel = NoticeViewModel(repository: repository)
        
        return viewModel
    }
    
    var settingViewModel: SettingViewModel {
        return SettingViewModel()
    }
    
    private init() {}
}
