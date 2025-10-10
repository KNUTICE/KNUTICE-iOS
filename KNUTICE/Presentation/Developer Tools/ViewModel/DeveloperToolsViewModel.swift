//
//  DeveloperToolsViewModel.swift
//  KNUTICE dev
//
//  Created by 이정훈 on 11/2/24.
//

import Combine
import Factory
import KNUTICECore
import os

@MainActor
final class DeveloperToolsViewModel: ObservableObject {
    @Published var fcmToken: String?
    
    private var cancellables: Set<AnyCancellable> = []
    private let logger = Logger(subsystem: "KNUTICE.DeveloperTools", category: "FCMToken")
    
    func fetchFCMToken() {
        FCMTokenManager.shared.getToken()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.debug("The request to fetch the FCM token has been completed")
                case .failure(let error):
                    self?.logger.error("DeveloperToolsViewModel.fetchFCMToken() failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.fcmToken = $0
            })
            .store(in: &cancellables)
    }
}
