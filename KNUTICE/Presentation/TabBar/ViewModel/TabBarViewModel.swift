//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine
import Factory
import RxRelay
import os

final class TabBarViewModel {
    let mainPopupContent: BehaviorRelay<MainPopupContent?> = .init(value: nil)
    let pushNotice: BehaviorRelay<Notice?> = .init(value: nil)
    
    @Injected(\.tabBarService) private var service: TabBarService
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    func fetchMainPopupContent() {
        service.fetchMainPopupContent()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.debug("Successfully fetched a mainPopupContent")
                case .failure(let error):
                    self?.logger.error("TabBarViewModel.fetchMainPopupContent(): Failed to fetch a mainPopupContent: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.mainPopupContent.accept($0)
            }
            .store(in: &cancellables)
    }
    
    func fetchPushNoticeIfExists() {
        service.fetchPushNotice()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.debug("Successfully fetched a PushNotice")
                case .failure(let error):
                    self?.logger.error("TabBarViewModel.fetchPushNotice() error: \(error)")
                }
            }, receiveValue: { [weak self] in
                self?.pushNotice.accept($0)
            })
            .store(in: &cancellables)
    }
}
