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
    @Published var isGeneralNoticeNotificationSubscribed: Bool?
    @Published var isAcademicNoticeNotificationSubscribed: Bool?
    @Published var isScholarshipNoticeNotificationSubscribed: Bool?
    @Published var isEventNoticeNotificationSubscribed: Bool?
    @Published var isEmploymentNoticeNotificationSubscribed: Bool?
    @Published var isMajorNoticeNotificationSubscribed: Bool?
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    
    @Injected(\.topicSubscriptionRepository) private var repository
    private let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    private(set) var alertMessage: String = ""
    private(set) var task: Task<Void, Never>?
    
    func fetchNotificationSubscriptions() async {
        defer { isLoading = false }
        
        isLoading = true
        
        do {
            let subscriptions = try await repository.fetch(for: .notice)

            for subscription in subscriptions {
                guard case .notice(let topic) = subscription else { continue }
                
                switch topic {
                case .generalNotice:
                    isGeneralNoticeNotificationSubscribed = true
                case .academicNotice:
                    isAcademicNoticeNotificationSubscribed = true
                case .scholarshipNotice:
                    isScholarshipNoticeNotificationSubscribed = true
                case .eventNotice:
                    isEventNoticeNotificationSubscribed = true
                case .employmentNotice:
                    isEmploymentNoticeNotificationSubscribed = true
                }
            }
            
            isMajorNoticeNotificationSubscribed = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
        } catch {
            logger.log(level: .error, "NotificationListViewModel.fetchNotificationSubscriptions(): \(error.localizedDescription)")
        }
    }
    
    func update<T>(of type: TopicType, topic: T, isEnabled: Bool) where T: RawRepresentable & Sendable, T.RawValue == String {
        task = Task {
            defer { isLoading = false }
            
            isLoading = true
            
            do {
                try await repository.update(of: type, topic: topic, isEnabled: isEnabled)
                
                if let topic = topic as? NoticeCategory {
                    switch topic {
                    case .generalNotice:
                        isGeneralNoticeNotificationSubscribed = isEnabled
                    case .academicNotice:
                        isAcademicNoticeNotificationSubscribed = isEnabled
                    case .scholarshipNotice:
                        isScholarshipNoticeNotificationSubscribed = isEnabled
                    case .eventNotice:
                        isEventNoticeNotificationSubscribed = isEnabled
                    case .employmentNotice:
                        isEmploymentNoticeNotificationSubscribed = isEnabled
                    }
                } else if let _ = topic as? MajorCategory {
                    isMajorNoticeNotificationSubscribed = isEnabled
                    UserDefaults.standard.set(isEnabled, forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
                }
            } catch {
                logger.log(level: .error, "NotificationListViewModel.update(key:value:): \(error.localizedDescription)")
            }
        }
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
