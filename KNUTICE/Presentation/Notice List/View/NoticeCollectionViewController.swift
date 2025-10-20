//
//  NoticeCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/7/25.
//

import UIKit
import SwiftUI
import RxSwift
import KNUTICECore

typealias NoticeCollectionViewConfigurable = UICollectionViewDelegateFlowLayout & CompositionalLayoutConfigurable & RxDataSourceBindable

class NoticeCollectionViewController<Category>: UIViewController, NoticeCollectionViewConfigurable where Category: RawRepresentable & Sendable, Category.RawValue == String {
    lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(NoticeCollectionViewCell.self, forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier)
        collectionView.register(NoticeCollectionViewCellWithThumbnail.self, forCellWithReuseIdentifier: NoticeCollectionViewCellWithThumbnail.reuseIdentifier)
        collectionView.backgroundColor = .primaryBackground
        
        return collectionView
    }()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    private let currentColumnCount: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
    let viewModel: NoticeSectionModelProvidable
    private var fetchableViewModel: NoticeFetchable? {
        return viewModel as? NoticeFetchable
    }
    private let navigationTitle: String
    let disposeBag = DisposeBag()
    
    init(viewModel: NoticeCollectionViewModel<Category>, navigationTitle: String = "") {
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
        setupLayout()
        setupBackground()
        setUpNavigationBar(title: navigationTitle)
        bind()
        
        if Category.self == NoticeCategory.self {
            fetchableViewModel?.fetchNotices()
        }
    }
    
    // FIXME: macOS(Designed for iPad)에서 NoticeDetailView 충돌 이슈
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let notice = viewModel.notices.value[0].items[indexPath.row]
        let viewController = NoticeDetailViewController(notice: notice)
        
//        if #available(iOS 26, *) {
//            viewController = UIHostingController(
//                rootView: NoticeDetailView()
//                    .environment(NoticeDetailViewModel(notice: notice))
//            )
//        } else {
//            viewController = NoticeDetailViewController(notice: notice)
//        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBackground() {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        collectionView.backgroundView = loadingIndicator
        collectionView.refreshControl = refreshControl
    }
    
    func bind() {
        bindNotices()
        bindWillDisplayCell()
        bindRefreshing()
        bindRefreshControl()
    }
    
    private func bindWillDisplayCell() {
        collectionView.rx.willDisplayCell
            .bind(with: self) { owner, cell in
                let (_, indexPath) = cell
                
                if let count = owner.viewModel.notices.value.first?.items.count,
                   indexPath.item == count - 1 {
                    owner.fetchableViewModel?.fetchNextPage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshing() {
        fetchableViewModel?.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.fetchableViewModel?.fetchNotices(isRefreshing: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setUpNavigationBar(title: String) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = title
    }
}

#if DEBUG
#Preview {
    NoticeCollectionViewController(
        viewModel: NoticeCollectionViewModel(category: NoticeCategory.generalNotice),
        navigationTitle: "일반소식"
    )
    .makePreview()
}
#endif

