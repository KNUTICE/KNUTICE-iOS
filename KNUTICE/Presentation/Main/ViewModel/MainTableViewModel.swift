//
//  MainTableViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxSwift
import RxRelay
import Factory
import os

@MainActor
final class MainTableViewModel {
    private let notices = BehaviorRelay<[MainNoticeSectionModel]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: false)
    
    var noticesObservable: Observable<[MainNoticeSectionModel]> {
        return notices.asObservable()
    }
    
    var cellValues: [MainNoticeSectionModel] {
        return notices.value
    }
    
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    private let logger: Logger = Logger()
    var task: Task<Void, Never>?
    
    @Injected(\.noticeService) private var noticeService
    
    /// Fetches notices for the main view.
    ///
    /// This method first provides mock skeleton sections to update the UI immediately,
    /// then asynchronously fetches the actual top three notices for each category.
    /// When the real data arrives, it replaces the mock sections in `notices`.
    ///
    /// - Note: Errors during fetching are logged but do not prevent the UI
    ///         from showing skeleton placeholders.
    func fetchNotices() {
        task = Task {
            // Fetch mock data first (for skeleton loading state)
            let mockSections = await noticeService.fetchMockNotices().map { $0.toSectionOfNotice }
            notices.accept(mockSections)
            
            do {
                // Fetch actual top 3 notices per category
                let fetchedSections = try await noticeService.fetchTopThreeNotices().map { $0.toSectionOfNotice }
                notices.accept(fetchedSections)
            } catch {
                logger.error("MainTableViewModel.fetchNoticesWithCombine() error : \(error.localizedDescription)")
            }
        }
    }
    
    /// Refreshes the notices for the main view.
    ///
    /// This method sets the `isLoading` state to true, waits for a short delay (0.5 seconds)
    /// to simulate network latency or allow UI animations, then fetches the actual top three
    /// notices per category. Once the fetch is complete, it updates the `notices` property
    /// and resets the `isLoading` state.
    ///
    /// - Note: Any errors during fetching are logged but do not prevent `isLoading` from being reset.
    func refreshNotices() {
        isLoading.accept(true)
        task = Task {
            defer { isLoading.accept(false) }
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                
                let fetchedSections = try await noticeService.fetchTopThreeNotices().map { $0.toSectionOfNotice }
                notices.accept(fetchedSections)
            } catch {
                logger.error("MainTableViewModel.refreshNotices() error : \(error.localizedDescription)")
            }
        }
    }
}

fileprivate extension MainSectionNotice {
    var toSectionOfNotice: MainNoticeSectionModel {
        MainNoticeSectionModel(
            header: self.header,
            items: self.items
        )
    }
}
