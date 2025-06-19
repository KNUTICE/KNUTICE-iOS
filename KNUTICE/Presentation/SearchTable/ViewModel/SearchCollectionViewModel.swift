//
//  SearchCollectionViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import Factory
import RxRelay
import RxSwift
import os

final class SearchCollectionViewModel {
    let notices: BehaviorRelay<[NoticeSectionModel]> = .init(value: [])
    let keyword: BehaviorRelay<String> = .init(value: "")
    @Injected(\.searchRepository) private var repository
    private let disposeBag: DisposeBag = DisposeBag()
    private let logger: Logger = Logger()
    
    func search(_ keyword: String) {
        guard !keyword.isEmpty else {
            notices.accept([])
            return
        }
        
        repository.search(keyword: keyword)
            .map {
                NoticeSectionModel(items: $0)
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] notices in
                self?.notices.accept([notices])
            }, onFailure: { [weak self] error in
                self?.logger.log("SearchTableViewModel.search: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
