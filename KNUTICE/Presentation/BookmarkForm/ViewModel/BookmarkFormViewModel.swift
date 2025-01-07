//
//  BookmarkFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import Combine
import Foundation

final class BookmarkFormViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var alarmDate: Date = Date()
    @Published var isAlarmOn: Bool = false
    @Published var description: String = ""
}
