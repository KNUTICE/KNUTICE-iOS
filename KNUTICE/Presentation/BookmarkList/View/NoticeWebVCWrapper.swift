//
//  NoticeWebVCWrapper.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/12/25.
//

import SwiftUI

struct NoticeWebVCWrapper: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    init(notice: Notice) {
        self.viewController = WebViewController(notice: notice)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {}
}

#if DEBUG
#Preview {
    NoticeWebVCWrapper(notice: Notice.generalNoticesSampleData[0])
}
#endif
