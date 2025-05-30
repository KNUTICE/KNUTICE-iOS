//
//  NotificationSubscriptionListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import os

@MainActor
final class NotificationSubscriptionListViewModel: ObservableObject {
    @Published var isGeneralNoticeNotificationSubscribed: Bool?
    @Published var isAcademicNoticeNotificationSubscribed: Bool?
    @Published var isScholarshipNoticeNotificationSubscribed: Bool?
    @Published var isEventNoticeNotificationSubscribed: Bool?
    @Published var isEmploymentNoticeNotificationSubscribed: Bool?
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    
    @Injected(\.notificationRepository) private var repository
    @Injected(\.subscriptionService) private var subscriptionService
    private let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    private(set) var alertMessage: String = ""
    private(set) var task: Task<Void, Never>?
    
    var isAllDataLoaded: Bool {
        let data = [
            isGeneralNoticeNotificationSubscribed,
            isAcademicNoticeNotificationSubscribed,
            isScholarshipNoticeNotificationSubscribed,
            isEventNoticeNotificationSubscribed
        ]
        
        return data.allSatisfy { $0 != nil }
    }
    
    func fetchNotificationSubscriptions() async {
        isLoading = true
        let result = await repository.fetch()
        
        guard !Task.isCancelled else {
            return
        }
        
        isLoading = false
        switch result {
        case .success(let subscriptions):
            isGeneralNoticeNotificationSubscribed = subscriptions.generalNotice
            isAcademicNoticeNotificationSubscribed = subscriptions.academicNotice
            isScholarshipNoticeNotificationSubscribed = subscriptions.scholarshipNotice
            isEventNoticeNotificationSubscribed = subscriptions.eventNotice
            isEmploymentNoticeNotificationSubscribed = subscriptions.employmentNotice
        case .failure(let error):
            logger.log(level: .error, "NotificationListViewModel.fetchNotificationSubscriptions(): \(error.localizedDescription)")
        }
    }
    
    func update(key: NoticeCategory, value: Bool) {
        task = Task {
            isLoading = true
            let result = await subscriptionService.update(key, to: value)
            
            guard !Task.isCancelled else {
                return
            }
            
            isLoading = false
            switch result {
            case .success:
                switch key {
                case .generalNotice:
                    isGeneralNoticeNotificationSubscribed = value
                case .academicNotice:
                    isAcademicNoticeNotificationSubscribed = value
                case .scholarshipNotice:
                    isScholarshipNoticeNotificationSubscribed = value
                case .eventNotice:
                    isEventNoticeNotificationSubscribed = value
                case .employmentNotice:
                    isEmploymentNoticeNotificationSubscribed = value
                }
            case .failure(let error):
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
