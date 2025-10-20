//
//  MajorNoticeCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/25/25.
//

import Combine
import KNUTICECore
import RxSwift
import SwiftUI
import UIKit

final class MajorNoticeCollectionViewController: NoticeCollectionViewController<MajorCategory>, SettingButtonConfigurable, SecondTabNavigationItemConfigurable {
    private var majorNoticeViewModel: NoticeCollectionViewModel<MajorCategory>? {
        return viewModel as? NoticeCollectionViewModel<MajorCategory>
    }
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        majorNoticeViewModel?.bindWithCategory()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            makeMajorSelectionButton()
            setSettingBarButtonItem()
        }
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupBackground() {
        collectionView.backgroundView = UIHostingController(rootView: MajorNoticeBackgroundView()).view
    }
    
    override func bind() {
        super.bind()
        
        majorNoticeViewModel?.$category
            .sink(receiveValue: { [weak self] in
                self?.makeMajorSelectionButton(withTitle: $0?.localizedDescription)
            })
            .store(in: &cancellables)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NotificationCenter.default.publisher(for: .majorSelectionDidChange)
                .sink(receiveValue: { [weak self] notification in
                    if let viewModel = self?.viewModel as? NoticeCollectionViewModel<MajorCategory>,
                       let category = notification.userInfo?[UserInfoKeys.selectedMajor] as? MajorCategory {
                        viewModel.category = category
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    @objc func didTapMajorSelectionButton(_ sender: UIButton) {
        guard let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> else { return }
        
        let viewController = UIHostingController(
            rootView: MajorSelectionView(selectedCategory: Binding(
                get: {
                    viewModel.category
                },
                set: {
                    viewModel.category = $0
                }))
        )
        viewController.modalPresentationStyle = .pageSheet
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(viewController, animated: true)
    }
}

#if DEBUG
#Preview {
    MajorNoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: MajorCategory.computerScience))
        .makePreview()
        .ignoresSafeArea()
}
#endif

