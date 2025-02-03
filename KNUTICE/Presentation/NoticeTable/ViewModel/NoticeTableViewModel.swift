//
//  NoticeTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxRelay
import RxSwift
import Combine
import os

final class NoticeTableViewModel: NoticeFetchable {
    let notices: BehaviorRelay = BehaviorRelay<[Notice]>(value: [])
    let isFetching: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    let isFinished: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    let isRefreshing: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    private let repository: NoticeRepository
    private var cancellables: Set<AnyCancellable> = []
    private var logger: Logger = Logger()
    
    init(repository: NoticeRepository) {
        self.repository = repository
    }
}

extension NoticeTableViewModel: NoticesRepresentable {
    func fetchNotices() {
        isFetching.accept(true)    //네트워크 요청 시작
        
        repository.fetchNotices()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("Successfully fetched Notices")
                case .failure(let error):
                    self?.logger.error("NoticeViewModel.fetchNotices() error: \(error.localizedDescription)")
                }
                
                self?.isFetching.accept(false)
            }, receiveValue: { [weak self] in
                self?.notices.accept($0)
            })
            .store(in: &cancellables)
    }
    
    func refreshNotices() {
        isRefreshing.accept(true)
        
        repository.fetchNotices()
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("Successfully fetched Notices")
                case .failure(let error):
                    self?.logger.error("NoticeViewModel.refreshNotices() error: \(error.localizedDescription)")
                }
                
                self?.isRefreshing.accept(false)
            }, receiveValue: { [weak self] in
                self?.notices.accept($0)
            })
            .store(in: &cancellables)
    }
    
    func fetchNextNotices() {
        guard let lastNumber = notices.value.last?.id, !isFinished.value else {
            return
        }
        
        isFetching.accept(true)
        repository.fetchNotices(after: lastNumber)
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info( "Successfully fetched next Notices")
                case .failure(let error):
                    self?.logger.error("NoticeViewModel.fetchNextNotices() error: \(error.localizedDescription)")
                }
                self?.isFetching.accept(false)
            }, receiveValue: { [weak self] in
                var currentNotices = self?.notices.value
                currentNotices? += $0
                
                guard let currentNotices else {
                    return
                }
                
                self?.notices.accept(currentNotices)
            })
            .store(in: &cancellables)
    }
}
