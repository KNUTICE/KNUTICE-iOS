//
//  Factory+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/7/25.
//

import Factory

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
    
    //MARK: - ViewModel
    var mainViewModel: Factory<MainViewModel> {
        Factory(self) {
            MainViewModel()
        }
    }
}
