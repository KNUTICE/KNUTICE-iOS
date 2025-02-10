//
//  NotificationListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import Factory
import os

final class NotificationListViewModel: ObservableObject {
    @Published var isGeneralNoticeNotificationAllowed: Bool?
    @Published var isAcademicNoticeNotificationAllowd: Bool?
    @Published var isScholarshipNoticeNotificationAllowed: Bool?
    @Published var isEventNoticeNotificationAllowed: Bool?
    @Published var isLoading: Bool = false
    
    @Injected(\.localNotificationRepository) private var repository: LocalNotificationRepository
    @Injected(\.notificationService) private var notificationService: NotificationService
    private let logger = Logger()
    private var cancellables = Set<AnyCancellable>()
    
    var isAllDataLoaded: Bool {
        let data = [
            isGeneralNoticeNotificationAllowed,
            isAcademicNoticeNotificationAllowd,
            isScholarshipNoticeNotificationAllowed,
            isEventNoticeNotificationAllowed
        ]
        
        return data.allSatisfy { $0 == true }
    }
    
    func getNotificationPermissions() {
        isLoading = true
        repository.getNotificationPermissions()
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
                self?.isGeneralNoticeNotificationAllowed = $0["generalNotice"]
                self?.isAcademicNoticeNotificationAllowd = $0["academicNotice"]
                self?.isScholarshipNoticeNotificationAllowed = $0["scholarshipNotice"]
                self?.isEventNoticeNotificationAllowed = $0["eventNotice"]
            })
            .store(in: &cancellables)
    }
    
    func update(key: NotificationKind, value: Bool) {
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
                }
            }, receiveValue: { [weak self] in
                switch key {
                case .generalNotice:
                    self?.isGeneralNoticeNotificationAllowed? = value
                case .academicNotice:
                    self?.isAcademicNoticeNotificationAllowd? = value
                case .scholarshipNotice:
                    self?.isScholarshipNoticeNotificationAllowed? = value
                case .eventNotice:
                    self?.isEventNoticeNotificationAllowed? = value
                }
            })
            .store(in: &cancellables)
    }
}
