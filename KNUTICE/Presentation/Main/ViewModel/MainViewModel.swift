//
//  MainViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

final class MainViewModel {
    var notices = BehaviorRelay<[SectionOfNotice]>(value: [])
    
    private let repository: MainNoticeRepository
    private let disposeBag = DisposeBag()
    
    init(repository: MainNoticeRepository) {
        self.repository = repository
        self.fetchNotices()
    }
    
    func getCellData() -> Observable<[SectionOfNotice]> {
        return notices.asObservable()
    }
    
    func fetchNotices() {
        repository.fetchMainNotices()
            .subscribe(onNext: { [weak self] result in
                self?.notices.accept(result)
            })
            .disposed(by: disposeBag)
    }
}
