//
//  NoticeContentView.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/12/25.
//

import KNUTICECore
import SwiftUI

struct NoticeContentView: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    init(notice: Notice) {
        self.viewController = NoticeContentViewController(
            viewModel: NoticeContentViewModel(notice: notice)
        )
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {}
}

#if DEBUG
#Preview {
    NoticeContentView(notice: Notice.generalNoticesSampleData[0])
}
#endif
