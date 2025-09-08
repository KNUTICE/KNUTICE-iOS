//
//  NoticeContentViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import Combine
import UIKit
import SwiftUI
import KNUTICECore

final class NoticeContentViewController: NoticeWebViewController {
    var viewModel: NoticeContentViewModel
    var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: NoticeContentViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
        viewModel.fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.task?.cancel()
    }
}

extension NoticeContentViewController {
    @objc override func openSharePanel() {
        guard let notice = viewModel.notice else { return }
        
        let shareText = notice.contentUrl
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
        guard let notice = viewModel.notice else { return }
        
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
        NoticeContentViewController(
            viewModel: NoticeContentViewModel(nttId: 1081703)
        )
        .makePreview()
    }
}
#endif
