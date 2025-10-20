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
        
        bindCategoryTitle()
        bindMajorSelectionNotificationIfNeeded()
        bindFetchingState()
    }

    private func bindCategoryTitle() {
        majorNoticeViewModel?.$category
            .sink { [weak self] category in
                self?.makeMajorSelectionButton(withTitle: category?.localizedDescription)
            }
            .store(in: &cancellables)
    }

    private func bindMajorSelectionNotificationIfNeeded() {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        
        NotificationCenter.default.publisher(for: .majorSelectionDidChange)
            .sink { [weak self] notification in
                guard
                    let self,
                    let viewModel = self.viewModel as? NoticeCollectionViewModel<MajorCategory>,
                    let category = notification.userInfo?[UserInfoKeys.selectedMajor] as? MajorCategory
                else { return }
                
                viewModel.category = category
            }
            .store(in: &cancellables)
    }
    
    private func bindFetchingState() {
        majorNoticeViewModel?.isFetching
            .subscribe(onNext: { [weak self] isFetching in
                if isFetching {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.startAnimating()
                    self?.collectionView.backgroundView = loadingIndicator
                }
            })
            .disposed(by: disposeBag)
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

