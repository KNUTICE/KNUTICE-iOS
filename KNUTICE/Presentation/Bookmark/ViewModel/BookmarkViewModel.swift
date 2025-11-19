//
//  BookmarkFormViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import Factory
import Foundation
import KNUTICECore
import os

@MainActor
final class BookmarkViewModel: ObservableObject {
    @Published var isAlarmOn: Bool
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var bookmark: Bookmark?
    
    @Injected(\.fetchBookmarksUseCase) private var fetchBookmarksUseCase
    @Injected(\.saveBookmarkUseCase) private var saveBookmarkUseCase
    @Injected(\.updateBookmarkUseCase) private var updateBookmarkUseCase
    @Injected(\.deleteBookmarkUseCase) private var deleteBookmarkUseCase
    
    private let nttId: Int?
    private(set) var alertMessage: String = ""
    private(set) var saveTask: Task<Void, Never>?
    private(set) var updateTask: Task<Void, Never>?
    private(set) var deleteTask: Task<Void, Never>?
    private let logger: Logger = Logger()
    
    init(bookmark: Bookmark?, nttId: Int? = nil) {
        self.nttId = nttId
        self.bookmark = bookmark
        self.isAlarmOn = bookmark?.alarmDate != nil
    }
    
    convenience init(nttId: Int) {
        self.init(bookmark: nil, nttId: nttId)
    }
    
    func save() {
        guard let bookmark else { return }
        
        isLoading = true
        saveTask?.cancel()
        saveTask = Task {
            defer {
                isLoading = false
                isShowingAlert = true
            }
            
            do {
                try await saveBookmarkUseCase.execute(bookmark)
                
                alertMessage = "북마크 저장이 완료 되었어요."
            } catch {
                handleSaveFailure(with: error)
            }
        }
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
        guard let bookmark else { return }
        
        isLoading = true
        updateTask?.cancel()
        updateTask = Task {
            defer {
                isLoading = false
                isShowingAlert = true
            }
            
            do {
                try await updateBookmarkUseCase.execute(for: bookmark)
                
                alertMessage = "저장을 완료했어요."
            } catch {
                handleSaveFailure(with: error)
            }
        }
    }
    
    func delete() {
        guard let bookmark else { return }
        
        isLoading = true
        deleteTask?.cancel()
        deleteTask = Task {
            defer {
                isLoading = false
                isShowingAlert = true
            }
            
            do {
                try await deleteBookmarkUseCase.execute(for: bookmark)
                
                alertMessage = "삭제를 완료 했어요."
            } catch {
                logger.error("BookmarkDetailViewModel.delete(by:): \(error.localizedDescription)")
                alertMessage = "삭제를 실패 했어요."
            }
        }
    }
    
    func fetchBookmark() async {
        guard let nttId else { return }
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let bookmark = try await fetchBookmarksUseCase.execute(for: nttId)
            self.bookmark = bookmark
            self.isAlarmOn = bookmark?.alarmDate != nil
        } catch {
            logger.error("BookmarkDetailViewModel.fetchBookmark(): \(error.localizedDescription)")
        }
    }
}
