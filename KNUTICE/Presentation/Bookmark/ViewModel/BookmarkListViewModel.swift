//
//  ReminderListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import Combine

final class BookmarkListViewModel: ObservableObject {
    @Published var uncompletedReminders: [Bookmark] = []
    @Published var completedReminders: [Bookmark] = []
    
    
}
