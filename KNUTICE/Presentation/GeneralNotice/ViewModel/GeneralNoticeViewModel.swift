//
//  GeneralNoticeViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxCocoa
import RxSwift

final class GeneralNoticeViewModel {
    private let notices = BehaviorRelay<[Notice]>(value: [])
    private let repository: GeneralNoticeRepository
    private let disposeBag = DisposeBag()
    
    init(repository: GeneralNoticeRepository) {
        self.repository = repository
        
        fetchNotices()
    }
}

extension GeneralNoticeViewModel: ViewModel {
    func fetchNotices() {
        repository.fetchNotices()
            .subscribe(onNext: { [weak self] notices in
                self?.notices.accept(notices)
            })
            .disposed(by: disposeBag)
    }
    
    func getCellData() -> Observable<[Notice]> {
        return notices.asObservable()
    }
}

