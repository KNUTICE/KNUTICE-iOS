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
    
    var mainViewModel: MainViewModel {
        let dataSource = MainNoticeDataSourceImpl()
        let repository = MainNoticeRepositoryImpl(dataSource: dataSource)
        let viewModel = MainViewModel(repository: repository)
        
        return viewModel
    }
    
    private init() {}
}
