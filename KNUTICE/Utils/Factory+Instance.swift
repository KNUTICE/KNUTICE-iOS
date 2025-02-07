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
}
