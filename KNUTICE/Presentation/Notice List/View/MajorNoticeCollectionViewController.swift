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
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        
        if let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> {
            viewModel.bindWithCategory()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            makeMajorSelectionButton()
            makeSettingBarButtonItem()
        }
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        if let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> {
            viewModel.$category
                .sink(receiveValue: { [weak self] in
                    self?.makeMajorSelectionButton(withTitle: $0?.localizedDescription)
                })
                .store(in: &cancellables)
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NotificationCenter.default.publisher(for: .majorSelectionDidChange)
                .sink(receiveValue: { [weak self] notification in
                    if let viewModel = self?.viewModel as? NoticeCollectionViewModel<MajorCategory>,
                       let category = notification.userInfo?["selectedMajor"] as? MajorCategory {
                        viewModel.category = category
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView())
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapMajorSelectionButton(_ sender: UIButton) {
        guard let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> else { return }
        
        let viewController = UIHostingController(
            rootView: MajorSelectionView<NoticeCollectionViewModel<MajorCategory>>()
                .environmentObject(viewModel)
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

