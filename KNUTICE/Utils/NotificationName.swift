//
//  NotificationName+BookmarkListRegresh.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Foundation

extension Notification.Name {
    static let bookmarkRefresh = Notification.Name("bookmarkRefresh")
    static let bookmarkReload = Notification.Name("bookmarkReload")
    static let fcmToken = Notification.Name("FCMToken")
}
