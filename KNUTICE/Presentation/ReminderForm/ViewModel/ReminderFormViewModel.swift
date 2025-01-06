//
//  ReminderFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import Combine
import Foundation

enum ReminderTimeOffset: String, CaseIterable {
    case before30Minutes = "30분 전"
    case before1Hour = "1시간 전"
    case before1Day = "1일 전"
    case before1Week = "1주 전"
}

final class ReminderFormViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var isAlarmOn: Bool = false
    @Published var content: String = ""
    @Published var reminderTimeOffset: ReminderTimeOffset = .before30Minutes
}
