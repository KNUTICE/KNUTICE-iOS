//
//  NoticeTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxRelay
import RxSwift
import Combine
import Factory
import os

final class NoticeTableViewModel: NoticeFetchable {
    let notices: BehaviorRelay = BehaviorRelay<[Notice]>(value: [])
    let isFetching: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    let isRefreshing: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    @Injected(\.noticeRepository) private var repository: NoticeRepository
    private var category: NoticeCategory
    private var cancellables: Set<AnyCancellable> = []
    private var logger: Logger = Logger()
    
    init(category: NoticeCategory) {
        self.category = category
    }
}

extension NoticeTableViewModel: NoticesRepresentable {
    func fetchNotices() {
        isFetching.accept(true)    //네트워크 요청 시작
        
        repository.fetchNotices(for: category)
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
        
        repository.fetchNotices(for: category)
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
        guard let lastNumber = notices.value.last?.id else {
            return
        }
        
        isFetching.accept(true)
        repository.fetchNotices(for: category, after: lastNumber)
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
