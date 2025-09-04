//
//  BookmarkFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore
import os

final class BookmarkFormViewModel: ObservableObject, BookmarkListRefreshable {
    @Published var isAlarmOn: Bool
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var bookmark: Bookmark
    
    @Injected(\.bookmarkService) private var service: BookmarkService
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    var alertMessage: String = ""
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
        self.isAlarmOn = bookmark.alarmDate != nil
    }
    
    func save() {        
        isLoading = true
        service.save(bookmark: bookmark)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkFormViewModel: Successfully saved bookmark")
                case .failure(let error):
                    self?.handleSaveFailure(with: error)
                }
                
                self?.isLoading = false
                self?.isShowingAlert = true
            }, receiveValue: { [weak self] in
                self?.alertMessage = "북마크 저장이 완료 되었어요."
            })
            .store(in: &cancellables)
    }
    
    private func handleSaveFailure(with error: Error) {
        if let error = error as? ExistingBookmarkError, case .alreadyExist(let message) = error {
            alertMessage = message
        } else {
            logger.error("BookmarkFormViewModel error: \(error.localizedDescription)")
            alertMessage = "북마크 저장에 실패했어요."
        }
    }
    
    func update() {
        isLoading = true
        service.update(bookmark: bookmark)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.log(level: .debug, "BookmarkEditFormViewModel.save(with:) Successfully saved Bookmark")
                    self?.alertMessage = "저장을 완료했어요."
                case .failure(let error):
                    self?.logger.log(level: .error, "BookmarkEditFormViewModel.save(with:) Failed to save Bookmark: \(error.localizedDescription)")
                    self?.alertMessage = "저장을 실패했어요."
                }
                
                self?.isLoading = false
                self?.isShowingAlert = true
            }, receiveValue: {
                
            })
            .store(in: &cancellables)
    }
    
    func delete() {
        isLoading = true
        service.delete(bookmark: bookmark)
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
