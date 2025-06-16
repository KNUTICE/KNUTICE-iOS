//
//  PendingNoticeListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/16/25.
//

import Combine
import Factory
import os

@MainActor
final class PendingNoticeListViewModel: ObservableObject {
    @Published var notices: [Notice]?
    @Published var isLoading: Bool = false
    
    @Injected(\.pendingNoticeService) private var service
    private let logger: Logger = Logger()
    
    func fetch() async {
        let result = await service.fetchPendingNotices()
        
        guard !Task.isCancelled else { return }
        
        switch result {
        case .success(let notices):
            self.notices = notices
        case .failure(let error):
            logger.error("PendingNoticeListViewModel: fetch failed: \(error)")
        }
    }
}
