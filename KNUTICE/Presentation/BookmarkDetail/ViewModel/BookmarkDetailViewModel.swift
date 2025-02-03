//
//  BookmarkDetailViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Combine
import Foundation
import os

final class BookmarkDetailViewModel: ObservableObject, BookmarkListRefreshable {
    @Published private(set) var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    
    private let bookmarkService: BookmarkService
    private(set) var alertMessage: String?
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    init(bookmarkService: BookmarkService) {
        self.bookmarkService = bookmarkService
    }
    
    func delete(bookmark: Bookmark) {
        isLoading = true
        bookmarkService.delete(bookmark: bookmark)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.log(level: .debug, "BookmarkDetailViewModel.delete(by:): Bookmark deletion completed")
                    self?.alertMessage = "삭제를 완료 했어요."
                case .failure(let error):
                    self?.logger.error("BookmarkDetailViewModel.delete(by:): \(error.localizedDescription)")
                    self?.alertMessage = "삭제를 실패 했어요."
                }
                
                self?.isLoading = false
                self?.isShowingAlert = true
            }, receiveValue: {
                
            })
            .store(in: &cancellables)
    }
}
