//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import RxRelay
import Combine
import os

final class TabBarViewModel {
    let mainPopupContent: BehaviorRelay<MainPopupContent?> = .init(value: nil)
    
    private let repsotiroy: MainPopupContentRepository
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    init(repsotiroy: MainPopupContentRepository) {
        self.repsotiroy = repsotiroy
    }
    
    func fetchMainPopupContent() {
        repsotiroy.fetchMainPopupContent()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.debug("Successfully fetched a mainPopupContent")
                case .failure(let error):
                    self?.logger.error("TabBarViewModel.fetchMainPopupContent(): Failed to fetch a mainPopupContent: \(error)")
                }
            } receiveValue: { [weak self] value in
                self?.mainPopupContent.accept(value)
            }
            .store(in: &cancellables)
    }
}
