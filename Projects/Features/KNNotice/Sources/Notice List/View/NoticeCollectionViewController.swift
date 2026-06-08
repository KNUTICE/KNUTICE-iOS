//
//  NoticeCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/7/25.
//

import CorePresentation
import KNDesignSystem
import KNUtility
import SwiftUI
import UIKit
import RxSwift

typealias NoticeCollectionViewConfigurable = UICollectionViewDelegateFlowLayout & CompositionalLayoutConfigurable & RxDataSourceBindable

public class NoticeCollectionViewController: UIViewController, NoticeCollectionViewConfigurable {
    public lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(NoticeCollectionViewCell.self, forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        
        return collectionView
    }()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    public let viewModel: NoticeCollectionViewModel
    private let bookmarkFormFactory: BookmarkFormFactory
    public let disposeBag = DisposeBag()
    private let currentColumnCount: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
    
    public init(viewModel: NoticeCollectionViewModel, bookmarkFormFactory: BookmarkFormFactory) {
        self.viewModel = viewModel
        self.bookmarkFormFactory = bookmarkFormFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up
        setupLayout()
        setupBackground()
        bind()
        
        // Fetch Data
        viewModel.fetchNotices()
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let section = viewModel.notices.value.first,
              section.items.indices.contains(indexPath.row) else {
            return
        }
        
        let notice = section.items[indexPath.row].notice
        let viewController = NoticeContentViewController(viewModel: NoticeContentViewModel(notice: notice)) { [weak self] notice in
            self?.bookmarkFormFactory.make(for: notice)
        }
        
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
                    owner.viewModel.fetchNextPage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshing() {
        viewModel.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.fetchNotices(isRefreshing: true)
            }
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import KNDomain

struct MockBookamrkFormFactory: BookmarkFormFactory {
    func make(for notice: KNDomain.Notice) -> UIViewController { UIViewController() }
}

#Preview {
    NoticeCollectionViewController(
        viewModel: NoticeCollectionViewModel(category: NoticeCategory.generalNotice),
        bookmarkFormFactory: MockBookamrkFormFactory()
    )
    .makePreview()
}
#endif

