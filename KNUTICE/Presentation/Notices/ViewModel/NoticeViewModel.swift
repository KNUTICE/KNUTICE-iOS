//
//  GeneralNoticeViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxCocoa
import RxSwift

final class NoticeViewModel: NoticeFetchable {
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

extension NoticeViewModel: NoticesRepresentable {
    func fetchNotices() {
        isFetching.accept(true)    //네트워크 요청 시작
        
        repository.fetchNotices()
            .subscribe { [weak self] in
                switch $0 {
                case .success(let notices):
                    self?.notices.accept(notices)
                    self?.isFetching.accept(false)
                case .failure(let error):
                    print("fetchNotices error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func refreshNotices() {
        isRefreshing.accept(true)
        
        repository.fetchNotices()
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] in
                switch $0 {
                case .success(let notices):
                    self?.isRefreshing.accept(false)
                    self?.notices.accept(notices)
                case .failure(let error):
                    print("refreshNotices error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchNextNotices() {
        guard let lastNumber = notices.value.last?.id, !isFinished.value else {
            return
        }
        
        isFetching.accept(true)
        repository.fetchNotices(after: lastNumber)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] in
                switch $0 {
                case .success(let nextNotices):
                    var temp = self?.notices.value
                    temp? += nextNotices
                    
                    guard let temp else {
                        return
                    }
                    
                    self?.isFetching.accept(false)
                    self?.notices.accept(temp)
                    
                    if nextNotices.isEmpty {
                        self?.isFinished.accept(true)
                    }
                case .failure(let error):
                    print("fetchNextNotices error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
}
