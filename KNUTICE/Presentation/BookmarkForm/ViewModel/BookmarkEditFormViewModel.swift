//
//  BookmarkEditFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Combine
import Foundation
import os

final class BookmarkEditFormViewModel: BookmarkManager, BookmarkFormHandler {
    @Published var title: String
    @Published var alarmDate: Date
    @Published var isAlarmOn: Bool
    @Published var memo: String
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    
    var alertMessage: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private let logger: Logger = Logger()
    
    init(bookmark: Bookmark, repository: BookmarkRepository) {
        self.title = bookmark.notice.title
        self.alarmDate = bookmark.alarmDate ?? Date()
        self.isAlarmOn = bookmark.alarmDate == nil ? false : true
        self.memo = bookmark.memo
        super.init(repository: repository)
    }
    
    func save(with notice: Notice) {
        isLoading = true
        repository.update(bookmark: getBookmark(notice: notice))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.log(level: .debug, "BookmarkEditFormViewModel.save(with:) Successfully saved Bookmark")
                    self?.alertMessage = "저장을 완료했어요."
                case .failure(let error):
                    self?.alertMessage = "저장을 실패했어요."
                }
                
                self?.isLoading = false
                self?.isShowingAlert = true
            }, receiveValue: {
                
            })
            .store(in: &cancellables)
    }
    
    private func getBookmark(notice: Notice) -> Bookmark {
        Bookmark(notice: notice,
                 memo: memo,
                 alarmDate: isAlarmOn ? alarmDate : nil)
    }
}
