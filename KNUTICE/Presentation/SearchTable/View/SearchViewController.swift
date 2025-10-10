//
//  SearchCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import Factory
import RxSwift
import UIKit
import SwiftUI

final class SearchViewController: UIViewController, CompositionalLayoutConfigurable {
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(frame: .zero)
        control.insertSegment(withTitle: "공지", at: 0, animated: true)
        control.insertSegment(withTitle: "북마크", at: 1, animated: true)
        control.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ], for: .normal)
        control.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        return control
    }()
    lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(NoticeCollectionViewCell.self, forCellWithReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier)
        collectionView.register(NoticeCollectionViewCellWithThumbnail.self, forCellWithReuseIdentifier: NoticeCollectionViewCellWithThumbnail.reuseIdentifier)
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        collectionView.backgroundView = loadingIndicator
        collectionView.backgroundColor = .primaryBackground
        
        return collectionView
    }()
    lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 100    //cell height가 설정되기 전 임시 크기
        tableView.rowHeight = UITableView.automaticDimension    //동적 Height 설정
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .primaryBackground
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
        button.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        
        return button
    }()
    var sholdHideNoticeView: Bool? {
        didSet {
            guard let sholdHideNoticeView = self.sholdHideNoticeView else { return }
            self.collectionView.isHidden = sholdHideNoticeView
            self.bookmarkTableView.isHidden = !sholdHideNoticeView
            
        }
    }
    @Injected(\.searchCollectionViewModel) var viewModel
    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .primaryBackground
        setupLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let viewModel = viewModel as? Searchable {
            viewModel.tasks.forEach {
                $0.cancel()
            }
        }
    }
    
    private func resignFirstResponderIfNeeded() {
        searchBar.resignFirstResponder()
        updateSearchBarConstraints(isShowCancelButton: false)
    }

    @objc func cancelButtonAction(_ sender: UIButton) {
       resignFirstResponderIfNeeded()
    }
    
    @objc func didChangeValue(segment: UISegmentedControl) {
        self.sholdHideNoticeView = segment.selectedSegmentIndex != 0
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = NoticeDetailViewController(notice: viewModel.notices.value[0].items[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel as? Searchable {
            let bookmark = viewModel.bookmarks.value[indexPath.row]
            let viewController = UIHostingController(
                rootView: BookmarkDetailSwitchView(viewModel: BookmarkViewModel(bookmark: bookmark))
            )
            navigationController?.pushViewController(viewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponderIfNeeded()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchBarConstraints(isShowCancelButton: true)
    }
}

#if DEBUG
#Preview {
    SearchViewController()
        .makePreview()
        .ignoresSafeArea(.all)
}
#endif
