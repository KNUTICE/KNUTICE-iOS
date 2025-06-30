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
    /// Sends a notification to refresh bookmarks.
    /// - Note: Refreshes data with the **initial batch size (e.g., 20 items)** regardless of current state.
    func sendRefreshNotification() {
        NotificationCenter.default.post(
            name: .bookmarkRefresh,
            object: nil
        )
    }
    
    
    /// Sends a notification to reload bookmarks.
    /// - Note: Reloads data based on the **currently loaded item count**.
    func sendReloadNotification() {
        NotificationCenter.default.post(
            name: .bookmarkReload,
            object: nil
        )
    }
}
