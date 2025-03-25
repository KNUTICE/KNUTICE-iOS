//
//  SearchTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import RxSwift
import RxRelay
import Factory
import os

final class SearchTableViewModel: SearchResultRepresentable {
    let notices: BehaviorRelay<[Notice]?> = .init(value: nil)
    let isFetching: BehaviorRelay<Bool> = .init(value: false)
    let keyword: BehaviorRelay<String> = .init(value: "")
    
    var tableData: Observable<[Notice]> {
        return notices.map {
            $0 ?? []
        }
        .asObservable()
    }
    
    @Injected(\.searchRepository) private var repository: SearchRepository
    private let disposeBag = DisposeBag()
    private let logger = Logger(subsystem: "KNUTICE", category: "SearchTableViewModel")
    
    func search(_ keyword: String) {
        guard !keyword.isEmpty else {
            notices.accept(nil)
            return
        }
        
        isFetching.accept(true)
        repository.search(keyword: keyword)
            .subscribe(onSuccess: { [weak self] notices in
                self?.notices.accept(notices)
                self?.isFetching.accept(false)
            }, onFailure: { [weak self] error in
                self?.logger.log("SearchTableViewModel.search: \(error.localizedDescription)")
                self?.isFetching.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
