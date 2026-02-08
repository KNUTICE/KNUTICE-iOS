//
//  NoticeCollectionView.swift
//  KNCore
//
//  Created by 이정훈 on 2/8/26.
//

import SwiftUI

public struct NoticeCollectionView: UIViewControllerRepresentable {
    private let viewModel: NoticeCollectionViewModel
    
    public init(viewModel: NoticeCollectionViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIViewController(context: Context) -> NoticeCollectionViewController {
        let viewController = NoticeCollectionViewController(
            viewModel: viewModel,
            navigationTitle: ""
        )
        return viewController
    }

    public func updateUIViewController(_ uiViewController: NoticeCollectionViewController, context: Context) {}
}
