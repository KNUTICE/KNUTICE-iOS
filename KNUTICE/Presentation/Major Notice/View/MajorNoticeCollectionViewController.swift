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

final class MajorNoticeCollectionViewController: UIViewController, CompositionalLayoutConfigurable,  RxDataSourceProvidable, NoticeNavigatable {
    let viewModel: NoticeSectionModelProvidable = MajorNoticeCollectionViewModel()
    
    lazy var titleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "학과명"
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 3
        config.contentInsets = .zero
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            return outgoing
        }
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        let button = UIButton(type: .system)
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapTitleButton(_:)), for: .touchUpInside)
        
        return button
    }()
    lazy var stackView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [titleButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .primaryBackground
        
        return stackView
    }()
    lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NoticeCollectionViewCell.self, forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier)
        collectionView.register(NoticeCollectionViewCellWithThumbnail.self, forCellWithReuseIdentifier: NoticeCollectionViewCellWithThumbnail.reuseIdentifier)
//        let loadingIndicator = UIActivityIndicatorView(style: .large)
//        loadingIndicator.startAnimating()
//        collectionView.backgroundView = loadingIndicator
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .primaryBackground
        
        return collectionView
    }()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var cancellables: Set<AnyCancellable> = []
    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        setupLayout()
        bind()
        bindNotices()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let viewModel = viewModel as? MajorNoticeCollectionViewModel {
            viewModel.task?.cancel()
        }
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(44)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom)
        }
    }
    
    @objc private func didTapTitleButton(_ sender: UIButton) {
        if let viewModel = viewModel as? MajorNoticeCollectionViewModel {
            let viewController = UIHostingController(
                rootView: MajorSelectionView()
                    .environmentObject(viewModel)
            )
            viewController.modalPresentationStyle = .pageSheet
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            
            present(viewController, animated: true)
        }
    }

}

extension MajorNoticeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let notice = viewModel.notices.value[0].items[indexPath.row]
        navigateToDetail(of: notice)
    }
}

#if DEBUG
#Preview {
    MajorNoticeCollectionViewController()
        .makePreview()
        .ignoresSafeArea()
}
#endif

