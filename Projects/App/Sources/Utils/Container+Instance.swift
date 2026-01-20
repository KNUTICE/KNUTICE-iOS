//
//  Container+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/26.
//

import Factory
import KNTip
import KNNotice

extension Container {
    var fetchTipUseCase: Factory<FetchTipUseCase> {
        Factory(self) {
            FetchTipUseCaseImpl()
        }
    }
    
    @MainActor
    var mainViewModel: Factory<MainTableViewModel> {
        .mainActor(self) {
            MainTableViewModel()
        }
    }
    
    @MainActor
    var searchViewModel: Factory<SearchViewModel> {
        .mainActor(self) { SearchViewModel() }
    }
    
    @MainActor
    var bookmarkTableViewModel: Factory<BookmarkTableViewModel> {
        .mainActor(self) { BookmarkTableViewModel() }
    }
    
    @MainActor
    var parentViewModel: Factory<ParentViewModel> {
        .mainActor(self) { ParentViewModel() }
    }
}

extension Factory {
    @MainActor
    static func mainActor(
        _ container: ManagedContainer,
        key: StaticString = #function,
        _ factory: @escaping @MainActor () -> T
    ) -> Factory<T> where T: Sendable {
        Factory(container, key: key) {
            MainActor.assumeIsolated {
                factory()
            }
        }
    }
}
