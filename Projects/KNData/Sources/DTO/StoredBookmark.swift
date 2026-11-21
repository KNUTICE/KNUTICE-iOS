// Values passed between the SwiftData store and its repository.
// SwiftData models and their relationships stay inside the store actor.

import Foundation

struct StoredBookmark: Sendable {
    let notice: StoredNotice
    let memo: String
    let alarmDate: Date?
}

struct StoredNotice: Sendable {
    let id: Int
    let title: String
    let contentURL: URL?
    let isSummarizable: Bool
    let department: String?
    let uploadDate: String
    let imageURL: String?
    let topicId: Int
}
