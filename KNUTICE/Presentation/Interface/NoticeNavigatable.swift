//
//  NoticeNavigatable.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/28/25.
//

import KNUTICECore
import SwiftUI
import UIKit

@MainActor
protocol NoticeNavigatable {    
    func navigateToDetail(of notice: Notice)
}

extension NoticeNavigatable where Self: UIViewController {
    func navigateToDetail(of notice: Notice) {
        let viewController: UIViewController
        
        if #available(iOS 26, *) {
            viewController = UIHostingController(
                rootView: NoticeDetailView()
                    .environment(NoticeDetailViewModel(notice: notice))
            )
        } else {
            viewController = NoticeDetailViewController(notice: notice)
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

