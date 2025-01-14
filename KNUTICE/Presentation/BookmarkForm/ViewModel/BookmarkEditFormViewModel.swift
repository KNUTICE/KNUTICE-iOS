//
//  BookmarkEditFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Combine
import Foundation

final class BookmarkEditFormViewModel: BookmarkManager, BookmarkFormHandler {
    @Published var title: String
    @Published var alarmDate: Date
    @Published var isAlarmOn: Bool
    @Published var memo: String
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    
    var alertMessage: String = ""
    
    init(bookmark: Bookmark, repository: BookmarkRepository) {
        self.title = bookmark.notice.title
        self.alarmDate = bookmark.alarmDate ?? Date()
        self.isAlarmOn = bookmark.alarmDate == nil ? false : true
        self.memo = bookmark.memo
        super.init(repository: repository)
    }
    
    func save(with notice: Notice) {
        //TODO: 업데이트 로직
    }
}
