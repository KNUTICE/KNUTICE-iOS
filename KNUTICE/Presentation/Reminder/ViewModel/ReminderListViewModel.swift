//
//  ReminderListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import Combine

final class ReminderListViewModel: ObservableObject {
    @Published var uncompletedReminders: [Reminder] = []
    @Published var completedReminders: [Reminder] = []
    
    
}
