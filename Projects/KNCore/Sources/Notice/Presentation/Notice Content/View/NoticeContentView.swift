//
//  NoticeContentView.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/12/25.
//

import SwiftUI

public struct NoticeContentView: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    public init(notice: Notice) {
        self.viewController = NoticeContentViewController(
            viewModel: NoticeContentViewModel(notice: notice)
        )
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {}
}

#if DEBUG
#Preview {
    NavigationStack {
        NoticeContentView(notice: Notice.generalNoticesSample[0])
    }
}
#endif
