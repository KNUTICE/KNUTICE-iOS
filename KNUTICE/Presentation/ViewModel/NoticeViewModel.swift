//
//  GeneralNoticeViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxCocoa
import RxSwift

final class NoticeViewModel {
    let notices: BehaviorRelay = BehaviorRelay<[Notice]>(value: [])
    let isFetching: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    let isFinished: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    let isRefreshing: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    private let repository: NoticeRepository
    private let disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    init(repository: NoticeRepository) {
        self.repository = repository
    }
}

extension NoticeViewModel: ViewModel {
    func fetchNotices() {
        isFetching.accept(true)    //네트워크 요청 시작
        
        repository.fetchNotices()
            .subscribe(onNext: { [weak self] responseNotices in
                self?.notices.accept(responseNotices)
            }, onCompleted: { [weak self] in
                self?.isFetching.accept(false)
                print("Fetching Notices has been completed")
            })
            .disposed(by: disposeBag)
    }
    
    func refreshNotices() {
        isRefreshing.accept(true)
        
        repository.fetchNotices()
            .subscribe(onNext: { [weak self] responseNotices in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.isRefreshing.accept(false)
                    self?.notices.accept(responseNotices)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchNextNotices() {
        guard let lastNumber = notices.value.last?.id, !isFinished.value else {
            return
        }
        
        isFetching.accept(true)
        repository.fetchNotices(after: lastNumber)
            .subscribe(onNext: { [weak self] nextNotices in
                var temp = self?.notices.value
                temp? += nextNotices
                
                guard let temp else {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.isFetching.accept(false)
                    self?.notices.accept(temp)
                    
                    if nextNotices.isEmpty {
                        self?.isFinished.accept(true)
                    }
                }
            }, onCompleted: {
                print("Fetching Notices has been completed")
            })
            .disposed(by: disposeBag)
    }
}
