//
//  SearchCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import ComposableArchitecture
import CorePresentation
import Factory
import KNBookmark
import KNDesignSystem
import KNDomain
import KNNotice
import RxSwift
import SwiftUI
import UIKit

public final class SearchViewController: UIViewController, CompositionalLayoutConfigurable {
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(frame: .zero)
        control.insertSegment(withTitle: "공지", at: 0, animated: true)
        control.insertSegment(withTitle: "북마크", at: 1, animated: true)
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ],
            for: .normal
        )
        control.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ],
            for: .selected
        )
        control.selectedSegmentIndex = 0
        control.addTarget(
            self,
            action: #selector(didChangeValue(segment:)),
            for: .valueChanged
        )
        return control
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.register(
            NoticeCollectionViewCell.self,
            forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier
        )
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        collectionView.backgroundView = loadingIndicator
        collectionView.backgroundColor =
            KNDesignSystemAsset.primaryBackground.color

        return collectionView
    }()
    
    lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 100  //cell height가 설정되기 전 임시 크기
        tableView.rowHeight = UITableView.automaticDimension  //동적 Height 설정
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: BookmarkListRow.reuseIdentifier
        )
        tableView.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.delegate = self

        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "공지사항 검색"
        searchBar.backgroundImage = UIImage()

        return searchBar
    }()
    
    lazy var cancelButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton(configuration: configuration)
        button.setTitle("취소", for: .normal)
        button.addAction(
            UIAction { [weak self] _ in
                self?.resignFirstResponderIfNeeded()
            },
            for: .touchUpInside
        )

        return button
    }()
    
    private var sholdHideNoticeView: Bool? {
        didSet {
            guard let sholdHideNoticeView = self.sholdHideNoticeView else {
                return
            }
            self.collectionView.isHidden = sholdHideNoticeView
            self.bookmarkTableView.isHidden = !sholdHideNoticeView

        }
    }
    
    @Injected(\.searchViewModel) public var viewModel
    public let disposeBag: DisposeBag = .init()
    private let makeBookmarkFormViewController: (Notice) -> UIViewController?

    public init(makeBookmarkFormViewController: @escaping (Notice) -> UIViewController?) {
        self.makeBookmarkFormViewController = makeBookmarkFormViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        setupLayout()
        bind()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.nextNoticesPageTask?.cancel()
    }

    private func resignFirstResponderIfNeeded() {
        searchBar.resignFirstResponder()
        updateSearchBarConstraints(isShowCancelButton: false)
    }

    @objc func didChangeValue(segment: UISegmentedControl) {
        self.sholdHideNoticeView = segment.selectedSegmentIndex != 0
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let section = viewModel.notices.value.first,
              section.items.indices.contains(indexPath.row) else {
            return
        }
        
        let viewController = NoticeContentViewController(
            viewModel: NoticeContentViewModel(
                notice: section.items[indexPath.row].notice
            ),
            makeBookmarkFormViewController: makeBookmarkFormViewController
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let count = viewModel.notices.value.first?.items.count, indexPath.row == count - 1 {
            viewModel.fetchNextNoticesPage()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let bookmark = viewModel.bookmarks.value[indexPath.row]
        let store = Store(
            initialState: BookmarkContainerFeature.State.detail(
                BookmarkDetailFeature.State(
                    bookmark: bookmark,
                    nttId: bookmark.identity
                )
            ),
            reducer: { BookmarkContainerFeature() }
        )

        let rootView = BookmarkContainerView(
            store: store,
            dismissAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        let viewController = UIHostingController(rootView: rootView)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponderIfNeeded()
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchBarConstraints(isShowCancelButton: true)
    }
}

#if DEBUG
#Preview {
    SearchViewController { _ in UIViewController() }
        .makePreview()
        .ignoresSafeArea(.all)
}
#endif
