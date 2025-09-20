//
//  NoticeDetailViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/19/25.
//

import Factory
import Foundation
import KNUTICECore
import os

@available(iOS 26, *)
final class NoticeDetailViewModel: WebContentViewModel {
    var notice: Notice? = nil
    var didHideIrrelevantElements: Bool = false
    
    @ObservationIgnored
    private let noticeId: Int
    
    @ObservationIgnored
    @Injected(\.noticeRepository) private var repository
    
    @ObservationIgnored
    var tasks: [Task<Void, Never>] = []
    
    @ObservationIgnored
    private let logger = Logger()
    
    // Designated initializer centralizing state setup
    init(noticeId: Int?, notice: Notice?) {
        self.notice = notice
        
        if let notice {
            self.noticeId = notice.id
            super.init(contentURL: notice.contentUrl)
        } else if let noticeId {
            self.noticeId = noticeId
            super.init(contentURL: nil)
        } else {
            // Fallback to an invalid id when neither is provided; adjust as needed
            self.noticeId = -1
            super.init(contentURL: nil)
        }
    }

    // Convenience: initialize with only notice id
    convenience init(noticeId: Int) {
        self.init(noticeId: noticeId, notice: nil)
    }

    // Convenience: initialize with a notice
    convenience init(notice: Notice) {
        self.init(noticeId: nil, notice: notice)
    }
    
    func fetchContent() {
        let task = Task {
            do {
                let notice = try await repository.fetchNotice(by: noticeId)
                
                guard let notice, let url = URL(string: notice.contentUrl) else { return }
                
                self.notice = notice
                self.webPage.load(url)
            } catch {
                logger.error("Failed to fetch notice content. Error: \(error.localizedDescription)")
            }
        }
        
        tasks.append(task)
    }
    
    func hideIrrelevantElements() {
        let task = Task {
            do {
                try await webPage.callJavaScript(
                    """
                    document.documentElement.style.webkitUserSelect='none';
                    document.documentElement.style.webkitTouchCallout='none';
                    document.getElementById(\"header\").style.display='none';
                    document.getElementById(\"footer\").style.display='none';
                    document.getElementById(\"remote\").style.display='none';
                    """
                )
                
                self.didHideIrrelevantElements = true
            } catch {
                // Log a detailed error with context
                logger.error("hideIrrelevantElements JavaScript injection failed. Error: \(error.localizedDescription)")
            }
        }
        
        tasks.append(task)
    }
    
}
