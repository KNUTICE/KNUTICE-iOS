//
//  NoticeSnapshotCreatable.swift
//  KNDomain
//
//  Created by 이정훈 on 6/7/26.
//

import Foundation

protocol NoticeSnapshotCreatable: NoticeNewPolicy {
    func createSnapshot(from notice: Notice) -> NoticeSnapshot
}

extension NoticeSnapshotCreatable {
    func createSnapshot(from notice: Notice) -> NoticeSnapshot {
        NoticeSnapshot(
            notice: notice,
            isNew: isNew(from: notice.uploadDate)
        )
    }
}

fileprivate struct NoticeDateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

protocol NoticeNewPolicy {
    func isNew(from date: String) -> Bool
}

extension NoticeNewPolicy {
    func isNew(from dateString: String) -> Bool {
        guard let date = NoticeDateFormatter.dateFormatter.date(from: dateString) else {
            return false
        }
        
        // Check if within 48 hours (172800 seconds)
        return abs(Date().timeIntervalSince(date)) < 172_800
    }
}
