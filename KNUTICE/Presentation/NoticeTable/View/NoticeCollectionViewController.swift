//
//  NoticeCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/7/25.
//

import UIKit
import SwiftUI
import RxSwift

final class NoticeCollectionViewController: UIViewController, CompositionalLayoutConfigurable {
    lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NoticeCollectionViewCell.self, forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier)
        collectionView.register(NoticeCollectionViewCellWithThumbnail.self, forCellWithReuseIdentifier: NoticeCollectionViewCellWithThumbnail.reuseIdentifier)
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        collectionView.backgroundView = loadingIndicator
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = .primaryBackground
        
        return collectionView
    }()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    private let currentColumnCount: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
    let viewModel: NoticeSectionModelProvidable
    private let navigationTitle: String
    let disposeBag = DisposeBag()
    
    init(viewModel: NoticeCollectionViewModel, navigationTitle: String = "") {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpLayout()
        setUpNavigationBar(title: navigationTitle)
        bind()
        
        if let viewModel = viewModel as? NoticeFetchable {
            viewModel.fetchNotices()
        }
    }
}

extension NoticeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let viewController = WebViewController(notice: viewModel.notices.value[0].items[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

#if DEBUG
#Preview {
    NoticeCollectionViewController(
        viewModel: NoticeCollectionViewModel(category: .generalNotice),
        navigationTitle: "일반소식"
    )
    .makePreview()
}
#endif
