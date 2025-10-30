//
//  NotificationSubscriptionListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import Foundation
import KNUTICECore
import os

@MainActor
final class TopicSubscriptionListViewModel: ObservableObject {
    @Published var noticeSubscriptionStates: [NoticeCategory: Bool] = [:]
    @Published var isMajorNoticeNotificationSubscribed: Bool?
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var isShowingFCMTokenErrorAlert: Bool = false
    
    @Injected(\.topicSubscriptionRepository) private var repository
    private let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    private(set) var alertMessage: String = ""
    private(set) var task: Task<Void, Never>?
    
    func fetchNotificationSubscriptions() async {
        defer { isLoading = false }
        
        isLoading = true
        
        do {
            // 각 공지 카테고리 별 구독 여부
            let subscriptions = try await repository.fetch(for: .notice)

            for subscription in subscriptions {
                guard case .notice(let topic) = subscription else { continue }
                
                noticeSubscriptionStates[topic] = true
            }
            
            // 학과 소식 구독 여부
            isMajorNoticeNotificationSubscribed = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
        } catch {
            guard let error = error.asAFError else {
                logger.log(level: .error, "NotificationListViewModel.fetchNotificationSubscriptions(): \(error.localizedDescription)")
                return
            }
            
            switch error {
            case .requestAdaptationFailed(let underlyingError):
                if let _ = underlyingError as? KNUTICECore.TokenError {
                    isShowingFCMTokenErrorAlert = true
                }
            default:
                break
            }
            
            logger.log(level: .error, "NotificationListViewModel.fetchNotificationSubscriptions(): \(error.localizedDescription)")
        }
    }
    
    func update(of type: TopicType, topic: NoticeCategory?, isEnabled: Bool) {
        task = Task {
            defer { isLoading = false }
            isLoading = true
            
            do {
                switch type {
                case .notice:
                    try await handleNoticeUpdate(topic: topic, isEnabled: isEnabled)
                case .major:
                    try await handleMajorUpdate(isEnabled: isEnabled)
                default:
                    // TODO: .meal 알림 설정 처리
                    break
                }
            } catch {
                logger.log(level: .error, "NotificationListViewModel.update(of:type:): \(error.localizedDescription)")
            }
        }
    }
    
    private func handleNoticeUpdate(topic: NoticeCategory?, isEnabled: Bool) async throws {
        guard let topic else { return }

        try await repository.update(of: .notice, topic: topic, isEnabled: isEnabled)
        noticeSubscriptionStates[topic] = isEnabled
    }
    
    private func handleMajorUpdate(isEnabled: Bool) async throws {
        guard let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue),
              let selectedMajor = MajorCategory(rawValue: majorStr) else {
            // 전공 선택이 없을 때는 로컬 업데이트만
            isMajorNoticeNotificationSubscribed = isEnabled
            UserDefaults.standard.set(isEnabled, forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
            return
        }
        
        try await repository.update(of: .major, topic: selectedMajor, isEnabled: isEnabled)
        
        isMajorNoticeNotificationSubscribed = isEnabled
        UserDefaults.standard.set(isEnabled, forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
    }
    
    private func handleError(with error: Error) {
        if let error = error as? RemoteServerError, case .invalidResponse(let message) = error {
            alertMessage = message
        } else {
            alertMessage = "잠시 후 다시 시도해주세요.\n지속적으로 발생할 경우 고객센터로 문의해주세요."
        }
        isShowingAlert = true
    }
    
}
