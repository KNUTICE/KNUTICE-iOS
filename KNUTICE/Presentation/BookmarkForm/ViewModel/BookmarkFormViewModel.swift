//
//  BookmarkFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import Combine
import Foundation
import os

final class BookmarkFormViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var alarmDate: Date = Date()
    @Published var isAlarmOn: Bool = false
    @Published var description: String = ""
    
    private let repository: BookmarkRepository
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger()
    
    init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    func save(with notice: Notice) {
        let bookmark = Bookmark(notice: notice, details: description, alarmDate: isAlarmOn ? alarmDate : nil)
        
        repository.save(bookmark: bookmark)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("BookmarkFormViewModel: Successfully saved bookmark")
                case .failure(let error):
                    self?.logger.error("BookmarkFormViewModel error: \(error.localizedDescription)")
                }
                
            }, receiveValue: {
                
            })
            .store(in: &cancellables)
    }
}
