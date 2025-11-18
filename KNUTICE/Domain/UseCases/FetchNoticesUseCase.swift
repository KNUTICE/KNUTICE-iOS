//
//  FetchNoticesUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/1/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore

protocol FetchNoticesUseCase: Actor {
    /// Fetches notices for the specified category and updates related user settings if necessary.
    ///
    /// This method performs the following tasks:
    /// - Checks for task cancellation.
    /// - If the category is a `MajorCategory` and the user has enabled major notifications,
    ///   updates the user’s subscription information accordingly.
    /// - Updates the user’s selected major category in `UserDefaults`.
    /// - Fetches notice data from the server for the specified category.
    ///
    /// - Parameters:
    ///   - category: The notice category to fetch, conforming to `CategoryProtocol`.
    ///   - nttId: The ID of the last fetched notice, used for pagination. Pass `nil` to fetch the latest notices.
    /// - Returns: An array of `Notice` objects fetched from the server.
    /// - Throws: An error if the task is cancelled, the subscription update fails, or fetching notices from the repository fails.
    func execute(category: some CategoryProtocol, after nttId: Int?) async throws -> [Notice]
}

extension FetchNoticesUseCase {
    func execute(category: some CategoryProtocol, after nttId: Int? = nil) async throws -> [Notice] {
        try await self.execute(category: category, after: nttId)
    }
}

actor FetchNoticesUseCaseImpl: FetchNoticesUseCase {
    @Injected(\.noticeRepository) private var noticeRepository
    @Injected(\.topicSubscriptionRepository) private var topicSubscriptionRepository
    
    func execute(category: some CategoryProtocol, after nttId: Int?) async throws -> [Notice] {
        try Task.checkCancellation()
        
        // 서버에서 가져올 공지 데이터가 학과 소식이면서, 사용자가 학과 소식 알림을 허용한 경우
        if let selectedMajorCategory = category as? MajorCategory {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue) {
                try await updateSubscription(of: selectedMajorCategory)
            }
            
            // UserDefaultsKeys.selectedMajor 업데이트
            UserDefaults.shared?.set(category.rawValue, forKey: UserDefaultsKeys.selectedMajor.rawValue)
        }
        
        // 서버에서 선택된 공지 데이터 가져오기
        let notices = try await noticeRepository.fetchNotices(for: category.rawValue, after: nttId)
        
        return notices
    }
    
    private func updateSubscription(of category: MajorCategory) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            if let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue),
               let storedMajorCategory = MajorCategory(rawValue: majorStr),
               category != storedMajorCategory {
                group.addTask {
                    // 새로 선택된 학과 공지 알림 활성화
                    try await self.topicSubscriptionRepository.update(of: .major, topic: category, isEnabled: true)
                }
                
                group.addTask {
                    // 이전 선택된 학과 알림 비활성화
                    try await self.topicSubscriptionRepository.update(of: .major, topic: storedMajorCategory, isEnabled: false)
                }
            }
            
            try await group.waitForAll()
        }
    }
    
}
