//
//  GeneralNoticeViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxCocoa
import RxSwift

final class NoticeViewModel {
    let notices = BehaviorRelay<[Notice]>(value: [])
    private let repository: NoticeRepository
    private let disposeBag = DisposeBag()
    
    init(repository: NoticeRepository) {
        self.repository = repository
    }
}

extension NoticeViewModel: ViewModel {
    func fetchNotices() {
        repository.fetchNotices()
            .subscribe(onNext: { [weak self] notices in
                self?.notices.accept(notices)
            })
            .disposed(by: disposeBag)
    }
}
