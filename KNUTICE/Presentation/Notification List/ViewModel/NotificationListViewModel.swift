//
//  NotificationListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import os

final class NotificationListViewModel: ObservableObject {
    private let repository: NotificationRepository
    private let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func getNotificationPermissions() {
        repository.getNotificationPermissions()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.log(level: .debug, "Notification permission request finished.")
                case .failure(let error):
                    self?.logger.log(level: .error, "NotificationListViewModel: \(error.localizedDescription)")
                }
            }, receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
}
