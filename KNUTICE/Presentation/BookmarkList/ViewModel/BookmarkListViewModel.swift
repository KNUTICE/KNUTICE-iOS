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
    
    func fetchBookmarks(delay: Int) async {
        do {
            for try await bookmarkList in repository.read(delay: delay).values {
                self.bookmarkList = bookmarkList
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
                    await self?.fetchBookmarks(delay: 0)
                }
            }
            .store(in: &cancellables)
    }
}
