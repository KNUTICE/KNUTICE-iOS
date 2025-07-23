//
//  AppVersionViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/10/24.
//

import Combine
import Foundation
import UserNotifications

final class AppVersionViewModel: ObservableObject, AppVersionProvidable {
    @Published var appVersion: String = ""
    
    func getVersion() {
        appVersion = getAppVersion()
    }
}
