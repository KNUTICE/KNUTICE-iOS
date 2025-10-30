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
    static let hasTipData = Notification.Name("hasTipData")
    static let majorSelectionDidChange = Notification.Name("majorSelectionDidChange")
    static let bookmarkSortOptionDidChange = Notification.Name("bookmarkSortOptionDidChange")
    static let didCompleteNotificationAuthorizationRequest = Notification.Name("didCompleteNotificationAuthorizationRequest")
    static let didFinishLoading = Notification.Name("didFinishLoading")
}
