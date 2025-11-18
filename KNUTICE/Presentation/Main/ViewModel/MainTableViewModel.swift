//
//  MainTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import Combine
import RxSwift
import RxRelay
import Factory
import Foundation
import os

@MainActor
final class MainTableViewModel {
    private let notices = BehaviorRelay<[MainNoticeSectionModel]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: false)
    
    var noticesObservable: Observable<[MainNoticeSectionModel]> {
        return notices.asObservable()
    }
    
    var cellValues: [MainNoticeSectionModel] {
        return notices.value
    }
    
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    private let logger: Logger = Logger()
    private var cancellables: Set<AnyCancellable> = []
    
    @Injected(\.fetchTopThreeNoticesUseCase) private var fetchTopThreeNoticesUseCase
    
    // TODO: 스레드 스위칭 수정
    /// Fetches notices for the main view.
    ///
    /// This method first provides mock skeleton sections to update the UI immediately,
    /// then asynchronously fetches the actual top three notices for each category.
    /// When the real data arrives, it replaces the mock sections in `notices`.
    ///
    /// - Note: Errors during fetching are logged but do not prevent the UI
    ///         from showing skeleton placeholders.
    func fetchNotices(isRefresh: Bool = false) {
        if isRefresh { isLoading.accept(true) }
        
        fetchTopThreeNoticesUseCase.execute(isRefresh: isRefresh)
            .map { notices in notices.map { $0.toSectionModel } }
            .delay(for: isRefresh ? 0.5 : 0, scheduler: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if isRefresh { self?.isLoading.accept(false) }
                
                switch completion {
                case .finished:
                    self?.logger.info("MainTableViewModel.fetchNotices() completed successfully — notices fetched and updated.")
                case .failure(let error):
                    self?.logger.error("MainTableViewModel.fetchNotices() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] notices in
                self?.notices.accept(notices)
            })
            .store(in: &cancellables)
    }
    
}

fileprivate extension MainSectionNotice {
    var toSectionModel: MainNoticeSectionModel {
        MainNoticeSectionModel(
            header: self.header,
            items: self.items
        )
    }
}
