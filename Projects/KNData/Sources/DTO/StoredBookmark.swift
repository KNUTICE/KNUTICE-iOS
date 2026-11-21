import Foundation

/// Carries a bookmarked notice, its memo, and its alarm date between the SwiftData store and the repository.
struct StoredBookmark: Sendable {
    let notice: StoredNotice
    let memo: String
    let alarmDate: Date?
}
