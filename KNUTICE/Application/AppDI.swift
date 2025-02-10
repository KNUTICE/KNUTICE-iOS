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
    
    func createBookmarkFormViewModel() -> BookmarkFormViewModel {
        let repository = BookmarkRepositoryImpl()
        let service = BookmarkServiceImpl(repository: repository)
        let viewModel = BookmarkFormViewModel(service: service)
        
        return viewModel
    }
    
    func createBookmarkDetailViewModel() -> BookmarkDetailViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl()
        let service = BookmarkServiceImpl(repository: repository)
        let viewModel = BookmarkDetailViewModel(bookmarkService: service)
        
        return viewModel
    }
    
    func createBookmarkEditFormViewModel(from bookmark: Bookmark) -> BookmarkEditFormViewModel {
        let dataSource = LocalBookmarkDataSourceImpl.shared
        let repository = BookmarkRepositoryImpl()
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
