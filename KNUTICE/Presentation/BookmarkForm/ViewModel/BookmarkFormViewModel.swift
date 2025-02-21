//
//  BookmarkFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import Combine
import Factory
import Foundation
import os

final class BookmarkFormViewModel: ObservableObject, BookmarkFormHandler {
    @Published var title: String = ""
    @Published var alarmDate: Date = Date()
    @Published var isAlarmOn: Bool = false
    @Published var memo: String = ""
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    
    @Injected(\.bookmarkService) private var service: BookmarkService
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    var alertMessage: String = ""
    
    func save(with notice: Notice) {
        let bookmark = Bookmark(notice: notice, memo: memo, alarmDate: isAlarmOn ? alarmDate : nil)
        
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
}
