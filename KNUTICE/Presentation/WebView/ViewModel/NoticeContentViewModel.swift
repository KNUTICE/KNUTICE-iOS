//
//  NoticeContentViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore

@MainActor
final class NoticeContentViewModel {
    /// Holds the current notice information.
    @Published private(set) var notice: Notice? = nil
    
    /// Injected dependency that manages fetching notices from the data source.
    @Injected(\.noticeRepository) private var repository
    
    /// The unique identifier of the notice to be fetched.
    private(set) var nttId: Int?
    
    /// A reference to the asynchronous task, used to track or cancel ongoing operations.
    var task: Task<Void, Never>?
    
    init(notice: Notice?, nttId: Int?) {
        self.notice = notice
        self.nttId = nttId
    }
    
    convenience init(notice: Notice) {
        self.init(notice: notice, nttId: nil)
    }
    
    convenience init(nttId: Int) {
        self.init(notice: nil, nttId: nttId)
    }
    
    /// Fetches the notice detail from the server.
    ///
    /// - Note: This method runs asynchronously using `Task`.
    ///         Any previously running `task` may be replaced.
    /// - Important: Checks for cancellation using `Task.checkCancellation()`.
    /// - Throws: Can throw a network or decoding error during the fetch process.
    /// - Side Effects: The fetched `Notice` is assigned to the `notice` property.
    func fetch() {
        guard let nttId else { return }
        
        task = Task {
            do {
                try Task.checkCancellation()
                
                notice = try await repository.fetchNotice(by: nttId)
            } catch {
                print(error)
            }
        }
    }
}
