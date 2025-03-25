//
//  ReminderListViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import Combine
import Foundation
import os

@MainActor
final class BookmarkListViewModel: BookmarkManager, ObservableObject {
    @Published private(set) var bookmarkList: [Bookmark]? = nil
    
    private(set) var isBindingWithNotification: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger()
    
    func fetchBookmarks(delay: Int = 0) async {
        do {
            if !UserDefaults.standard.bool(forKey: "isBookmarkSyncedAfter1_4_0") {
                for try await bookmarkList in service.syncBookmarksWithNotice().values {
                    self.bookmarkList = bookmarkList
                }
                UserDefaults.standard.set(true, forKey: "isBookmarkSyncedAfter1_4_0")
            } else {
                for try await bookmarkList in repository.read(delay: delay).values {
                    self.bookmarkList = bookmarkList
                }
            }
        } catch {
            logger.error("BookmarkListViewModel.fetchBookmark() error: \(error.localizedDescription)")
        }
    }
    
    func bindingRefreshNotification() {
        isBindingWithNotification = true
        NotificationCenter.default.publisher(for: .bookmarkListRefresh)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task {
                    await self?.fetchBookmarks()
                }
            }
            .store(in: &cancellables)
    }
}
