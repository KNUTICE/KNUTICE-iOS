//
//  FetchNoticeUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/1/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore

protocol FetchNoticeUseCase: Actor {
    /// Executes a notice fetch request and updates topic subscription status
    /// when the selected category is a `MajorCategory`.
    ///
    /// - Parameters:
    ///   - category: The category of notices to fetch. Must conform to
    ///     `RawRepresentable & Sendable` with a `String` raw value.
    ///   - nttId: The reference notice ID to fetch notices after. Pass `nil`
    ///     to fetch from the beginning.
    /// - Returns: An array of `Notice` objects fetched from the server.
    /// - Throws:
    ///   - `CancellationError` if the task is cancelled.
    ///   - Any error thrown during the network or repository operations.
    /// - Note:
    ///   - If the category is a `MajorCategory`, the method enables the new
    ///     subscription and disables the previously stored one.
    ///   - Updates the value of `UserDefaultsKeys.selectedMajor` with the
    ///     newly selected category.
    func execute<T>(category: T, after nttId: Int?) async throws -> [Notice] where T: RawRepresentable & Sendable, T.RawValue == String
}

extension FetchNoticeUseCase {
    func execute<T>(category: T, after nttId: Int? = nil) async throws -> [Notice] where T: RawRepresentable & Sendable, T.RawValue == String {
        try await self.execute(category: category, after: nttId)
    }
}

actor FetchNoticeUseCaseImpl: FetchNoticeUseCase {
    @Injected(\.noticeRepository) private var noticeRepository
    @Injected(\.topicSubscriptionRepository) private var topicSubscriptionRepository
    
    func execute<T>(category: T, after nttId: Int?) async throws -> [Notice] where T : RawRepresentable & Sendable, T.RawValue == String {
        try Task.checkCancellation()
        
        // 서버에서 가져올 공지 데이터가 학과 소식이면서, 사용자가 학과 소식 알림을 허용한 경우
        if let selectedMajorCategory = category as? MajorCategory {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue) {
                try await updateSubscription(of: selectedMajorCategory)
            }
            
            // UserDefaultsKeys.selectedMajor 업데이트
            UserDefaults.standard.set(category.rawValue, forKey: UserDefaultsKeys.selectedMajor.rawValue)
        }
        
        // 서버에서 선택된 공지 데이터 가져오기
        let notices = try await noticeRepository.fetchNotices(for: category.rawValue, after: nttId)
        
        return notices
    }
    
    private func updateSubscription(of category: MajorCategory) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            if let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue),
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
