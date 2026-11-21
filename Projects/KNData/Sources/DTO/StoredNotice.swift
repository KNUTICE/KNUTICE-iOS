import Foundation

/// Carries the notice details included in a ``StoredBookmark``.
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
