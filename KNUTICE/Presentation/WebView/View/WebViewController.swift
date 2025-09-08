//
//  WebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit
import WebKit
import SwiftUI
import Foundation
import KNUTICECore

final class NoticeDetailWebViewController: NoticeWebViewController {
    private let notice: Notice
    
    init(notice: Notice) {
        self.notice = notice
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPage(notice.contentUrl)
    }
    
    private func loadPage(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
}

extension NoticeDetailWebViewController {
    @objc override func openSharePanel() {
        let shareText = self.notice.contentUrl
        let shareObject = [shareText]
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.showCompletionAlert()
            } else {
                
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc override func openBookmarkForm(_ sender: UIButton) {
        let bookmarkForm = BookmarkForm(for: .create) {
            self.dismiss(animated: true)
        }
        .environmentObject(
            BookmarkViewModel(bookmark: Bookmark(notice: notice, memo: ""))
        )
        let viewController = UIHostingController(rootView: bookmarkForm)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        NoticeDetailWebViewController(notice: Notice.generalNoticesSampleData.first!)
            .makePreview()
    }
}
#endif
