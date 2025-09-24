//
//  TabBarViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Factory
import KNUTICECore
import RxRelay
import os

@MainActor
final class TabBarViewModel {
    let pushNotice: BehaviorRelay<Notice?> = .init(value: nil)
    
    @Injected(\.pushNoticeService) private var service: PushNoticeService
    private let logger: Logger = Logger()
    private(set) var task: Task<Void, Never>?
    
    func fetchPushNoticeIfExists() {
        task = Task {
            do {
                let notice = try await service.fetchPushNotice()
                pushNotice.accept(notice)
            } catch {
                logger.error("TabBarViewModel.fetchPushNotice() error: \(error)")
            }
        }
    }
}
