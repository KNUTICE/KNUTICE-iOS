//
//  MajorNoticeCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/25/25.
//

import Combine
import KNDesignSystem
import KNSetting
import KNUtility
import RxSwift
import SwiftUI
import UIKit

@MainActor
public final class MajorNoticeCollectionViewController: NoticeCollectionViewController, SettingButtonConfigurable, SecondTabNavigationItemConfigurable {
    var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            setNoticeBarButtonItem()
            setSettingBarButtonItem()
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
        
        bindFetchingState()
    }
    
    private func bindFetchingState() {
        viewModel.isFetching
            .subscribe(onNext: { [weak self] isFetching in
                if isFetching {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.startAnimating()
                    self?.collectionView.backgroundView = loadingIndicator
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
#Preview {
    MajorNoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: MajorCategory.computerScience))
        .makePreview()
        .ignoresSafeArea()
}
#endif

