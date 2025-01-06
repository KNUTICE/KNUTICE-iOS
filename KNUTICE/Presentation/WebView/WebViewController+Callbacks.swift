//
//  WebViewController+Callbacks.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/8/24.
//

import UIKit
import SwiftUI

extension WebViewController {
    @objc
    func openSharePanel() {
        let shareText = self.url
        let shareObject = [shareText]
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.showCompleAlert()
            } else {
                
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showCompleAlert() {
        let alert = UIAlertController(title: "알림", message: "공유를 완료했어요.", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func openReminderForm(_ sender: UIButton) {
        let viewController = UIHostingController(rootView:
                                                    ReminderForm(viewModel: AppDI.shared.makeReminderFormViewModel(),
                                                                 isShowingSheet: .constant(true),
                                                                 url: self.url) { self.dismiss(animated: true) }
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .popover
        present(navigationController, animated: true, completion: nil)
    }
}
