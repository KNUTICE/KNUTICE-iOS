//
//  Container+Instance.swift
//  KNBookmark
//
//  Created by 이정훈 on 1/4/26.
//

import Factory
import KNData
import KNDomain
import KNNetwork
import KNUtility

extension Container {
    var bookmarkRepository: Factory<BookmarkRepository> {
        Factory(self) { BookmarkRepositoryImpl.shared }
    }
    
    var searchBookmarksUseCase: Factory<SearchBookmarksUseCase> {
        Factory(self) {
            SearchBookmarksUseCaseImpl(repository: self.bookmarkRepository())
        }
    }
    
    // [Notice Related]
    var searchNoticesUseCase: Factory<SearchNoticesUseCase> {
        Factory(self) {
            SearchNoticesUseCaseImpl(noticeRepository: NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl()))
        }
    }
    
    // [Composite / Utility]
    var searchNoticeAndBookmarkUseCase: Factory<SearchNoticeAndBookmarkUseCase> {
        Factory(self) {
            SearchNoticeAndBookmarkUseCaseImpl(searchNoticesUseCase: self.searchNoticesUseCase(), searchBookmarksUseCase: self.searchBookmarksUseCase())
        }
    }
    
    @MainActor
    var searchViewModel: Factory<SearchViewModel> {
        .mainActor(self) { SearchViewModel() }
    }
}
