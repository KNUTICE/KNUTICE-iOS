//
//  NotificationSubscriptionListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import os

final class NotificationSubscriptionListViewModel: ObservableObject {
    @Published var isGeneralNoticeNotificationSubscribed: Bool?
    @Published var isAcademicNoticeNotificationSubscribed: Bool?
    @Published var isScholarshipNoticeNotificationSubscribed: Bool?
    @Published var isEventNoticeNotificationSubscribed: Bool?
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    
    @Injected(\.notificationRepository) private var repository: NotificationSubscriptionRepository
    @Injected(\.notificationService) private var notificationService: NotificationSubscriptionService
    private let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    private(set) var alertMessage: String = ""
    
    var isAllDataLoaded: Bool {
        let data = [
            isGeneralNoticeNotificationSubscribed,
            isAcademicNoticeNotificationSubscribed,
            isScholarshipNoticeNotificationSubscribed,
            isEventNoticeNotificationSubscribed
        ]
        
        return data.allSatisfy { $0 != nil }
    }
    
    func initializeAndFetchNotificationSubscriptions() {
        isLoading = true
        repository.createLocalSubscription()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("Successfully created initial subscription data")
                case .failure(let error):
                    self?.logger.error("NotificationSubscriptionListViewModel.initializeData() error : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchNotificationSubscriptions()
            })
            .store(in: &cancellables)
    }
    
    func fetchNotificationSubscriptions() {
        isLoading = true
        repository.fetchNotificationPermissions()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    self?.logger.log(level: .debug, "Notification permission request finished.")
                case .failure(let error):
                    self?.logger.log(level: .error, "NotificationListViewModel: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.isGeneralNoticeNotificationSubscribed = $0["generalNotice"]
                self?.isAcademicNoticeNotificationSubscribed = $0["academicNotice"]
                self?.isScholarshipNoticeNotificationSubscribed = $0["scholarshipNotice"]
                self?.isEventNoticeNotificationSubscribed = $0["eventNotice"]
            })
            .store(in: &cancellables)
    }
    
    func update(key: NoticeCategory, value: Bool) {
        isLoading = true
        notificationService.updatePermission(key, to: value)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    self?.logger.log(level: .debug, "Notification permission update finished.")
                case .failure(let error):
                    self?.logger.log(level: .error, "NotificationListViewModel: \(error.localizedDescription)")
                    self?.handleError(with: error)
                }
            }, receiveValue: { [weak self] in
                switch key {
                case .generalNotice:
                    self?.isGeneralNoticeNotificationSubscribed? = value
                case .academicNotice:
                    self?.isAcademicNoticeNotificationSubscribed? = value
                case .scholarshipNotice:
                    self?.isScholarshipNoticeNotificationSubscribed? = value
                case .eventNotice:
                    self?.isEventNoticeNotificationSubscribed? = value
                case .employmentNotice:
                    //TODO: 취업공지 구독 여부
                    break
                }
            })
            .store(in: &cancellables)
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
