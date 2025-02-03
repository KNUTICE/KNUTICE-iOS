//
//  BookmarkListRefreshable.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Foundation

protocol BookmarkListRefreshable {
    func sendRefreshNotification()
}

extension BookmarkListRefreshable {
    func sendRefreshNotification() {
        NotificationCenter.default.post(
            name: .bookmarkListRefresh,
            object: nil
        )
    }
}
