//
//  NotificationListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import os

final class NotificationListViewModel: ObservableObject {
    @Published var isGeneralNoticeNotificationAllowed: Bool?
    @Published var isAcademicNoticeNotificationAllowd: Bool?
    @Published var isScholarshipNoticeNotificationAllowed: Bool?
    @Published var isEventNoticeNotificationAllowed: Bool?
    @Published var isLoading: Bool = false
    
    private let repository: NotificationRepository
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
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func getNotificationPermissions() {
        isLoading = true
        repository.getNotificationPermissions()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
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
}
