//
//  BookmarkFormHandler.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Foundation

protocol BookmarkFormHandler: ObservableObject, BookmarkListRefreshable {
    var title: String { get set }
    var alarmDate: Date { get set }
    var isAlarmOn: Bool { get set }
    var memo: String { get set }
    var isShowingAlert: Bool { get set }
    var isLoading: Bool { get set }
    var alertMessage: String { get set }
    
    func save(with notice: Notice)
}
