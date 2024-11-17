//
//  SearchTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import RxSwift
import RxRelay
import os

final class SearchTableViewModel: NoticesRepresentable {
    let notices: BehaviorRelay<[Notice]> = .init(value: [])
    let isFetching: BehaviorRelay<Bool> = .init(value: false)
    let keyword: BehaviorRelay<String> = .init(value: "")
    private let repository: SearchRepository
    private let disposeBag = DisposeBag()
    private let logger = Logger(subsystem: "KNUTICE", category: "SearchTableViewModel")
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    func search(_ keyword: String) {
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
