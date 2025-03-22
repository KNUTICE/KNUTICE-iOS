//
//  MainTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxSwift
import RxRelay
import Combine
import Factory
import os

final class MainTableViewModel {
    private let notices = BehaviorRelay<[SectionOfNotice]>(value: [])
    var noticesObservable: Observable<[SectionOfNotice]> {
        return notices.asObservable()
    }
    private let isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    @Injected(\.mainNoticeRepository) private var repository: MainNoticeRepository
    private let disposeBag = DisposeBag()
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    func getCellValue() -> [SectionOfNotice] {
        return notices.value
    }
    
    ///Fetch Notices with RxSwift
    @available(*, deprecated, message: "Combine 함수 대체 사용")
    func fetchNotices() {
        repository.fetchMainNotices()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                //해당 스트림은 MainNoticeRepositoryImpl에서 onComplete()를 호출하기 때문에
                //[weak self]를 굳이 사용하지 않아도 reference count가 증가 되지는 않음.
                self?.notices.accept(result)
            })
            .disposed(by: disposeBag)
    }
    
    ///Fetch Notices with Combine
    func fetchNoticesWithCombine() {
        repository.fetch()
            .merge(with: repository.fetchTempData())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.debug("Successfully fetched main notice")
                case .failure(let error):
                    self?.logger.debug("MainViewModel.fetchNoticesWithCombine() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.notices.accept($0)
            })
            .store(in: &cancellables)
    }
    
    //Refresh Notices with RxSwift
    @available(*, deprecated, message: "Combine 함수 대체 사용")
    func refreshNotices() {
        isLoading.accept(true)
        
        repository.fetchMainNotices()
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.notices.accept(result)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    ///Refresh Notices with Combine
    func refreshNoticesWithCombine() {
        isLoading.accept(true)
        
        repository.fetch()
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading.accept(false)
                
                switch completion {
                case .finished:
                    self?.logger.debug("Successfully refreshed main notice")
                case .failure(let error):
                    self?.logger.error("MainViewModel.refreshNoticesWithCombine error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.notices.accept($0)
            })
            .store(in: &cancellables)
    }
}
