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
    var cellValues: [SectionOfNotice] {
        return notices.value
    }
    private let isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    @Injected(\.mainNoticeRepository) private var repository: MainNoticeRepository
    private let disposeBag = DisposeBag()
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
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
