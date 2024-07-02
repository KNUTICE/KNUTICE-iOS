//
//  MainViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxSwift
import RxRelay
import RxDataSources

final class MainViewModel {
    private(set) var notices = BehaviorRelay<[SectionOfNotice]>(value: [])
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
                //해당 스트림은 MainNoticeRepositoryImpl에서 onComplete()를 호출하기 때문에
                //[weak self]를 굳이 사용하지 않아도 reference count가 증가 되지는 않음.
                self?.notices.accept(result)
            })
            .disposed(by: disposeBag)
    }
}
