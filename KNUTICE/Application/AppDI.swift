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
    
    func createBookmarkDetailViewModel() -> BookmarkDetailViewModel {
        let service = BookmarkServiceImpl()
        let viewModel = BookmarkDetailViewModel(bookmarkService: service)
        
        return viewModel
    }
    
    func createTabBarViewModel() -> TabBarViewModel {
        let dataSource = RemoteDataSourceImpl.shared
        let repository = MainPopupContentRepositoryImpl(dataSource: dataSource)
        let viewModel = TabBarViewModel(repsotiroy: repository)
        
        return viewModel
    }
}
