//
//  SettingViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/10/24.
//

import Combine
import Foundation
import UserNotifications

final class SettingViewModel: ObservableObject {
    @Published var isToggleOn: Bool = false
    @Published var appVersion: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let notificationCenter =  UNUserNotificationCenter.current()
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self?.isToggleOn = true
                }
            } else {
                DispatchQueue.main.async {
                    self?.isToggleOn = false
                }
            }
        }
    }
    
    func getAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
    }
}
