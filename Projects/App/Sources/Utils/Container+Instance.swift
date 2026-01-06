//
//  Container+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/26.
//

import Factory
import KNTip

extension Container {
    var fetchTipUseCase: Factory<FetchTipUseCase> {
        Factory(self) {
            FetchTipUseCaseImpl()
        }
    }
    
    var mainViewModel: Factory<MainTableViewModel> {
        Factory(self) { @MainActor in
            MainTableViewModel()
        }
    }
    
    var searchViewModel: Factory<SearchViewModel> {
        Factory(self) { @MainActor in
            SearchViewModel()
        }
    }
    
    var bookmarkTableViewModel: Factory<BookmarkTableViewModel> {
        Factory(self) { @MainActor in
            BookmarkTableViewModel()
        }
    }
    
    var parentViewModel: Factory<ParentViewModel> {
        Factory(self) { @MainActor in
            ParentViewModel()
        }
    }
}
