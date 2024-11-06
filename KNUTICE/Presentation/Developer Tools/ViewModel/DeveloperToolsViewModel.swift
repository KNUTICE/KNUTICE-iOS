//
//  DeveloperToolsViewModel.swift
//  KNUTICE dev
//
//  Created by 이정훈 on 11/2/24.
//

import Combine
import os

final class DeveloperToolsViewModel: ObservableObject {
    @Published var fcmToken: String?
    
    private let tokenRepository: TokenRepository
    private var cancellables: Set<AnyCancellable> = []
    private let logger = Logger(subsystem: "KNUTICE.DeveloperTools", category: "FCMToken")
    
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    func fetchFCMToken() {
        tokenRepository.getFCMToken()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The request to fetch the FCM token has been completed")
                case .failure(let error):
                    print("DeveloperToolsViewModel.fetchFCMToken() failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.fcmToken = $0
            })
            .store(in: &cancellables)
    }
}
