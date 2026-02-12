//
//  Notification+Name.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Foundation

public extension Notification.Name {
    static let fcmToken = Notification.Name("FCMToken")
    static let majorSelectionDidChange = Notification.Name("majorSelectionDidChange")
    static let bookmarkSortOptionDidChange = Notification.Name("bookmarkSortOptionDidChange")
    static let didCompleteNotificationAuthorizationRequest = Notification.Name("didCompleteNotificationAuthorizationRequest")
    static let didFinishLoading = Notification.Name("didFinishLoading")
    static let didReceiveDeepLink = Notification.Name("didReceiveDeepLink")
}
