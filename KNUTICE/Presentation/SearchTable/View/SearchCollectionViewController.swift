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

final class SearchCollectionViewController: UIViewController, CompositionalLayoutConfigurable {
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
        
        return collectionView
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
    @Injected(\.searchCollectionViewModel) var viewModel
    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        bind()
    }
    
    private func resignFirstResponderIfNeeded() {
        searchBar.resignFirstResponder()
        updateSearchBarConstraints(isShowCancelButton: false)
    }
    

    @objc func cancelButtonAction(_ sender: UIButton) {
       resignFirstResponderIfNeeded()
    }

}

extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if #available(iOS 26, *) {
            let viewController = UIHostingController(
                rootView: WebNoticeView()
                    .environment(WebNoticeViewModel(notice: viewModel.notices.value[0].items[indexPath.row]))
            )
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = WebViewController(notice: viewModel.notices.value[0].items[indexPath.row])
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponderIfNeeded()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchBarConstraints(isShowCancelButton: true)
    }
}

#Preview {
    SearchCollectionViewController()
        .makePreview()
        .ignoresSafeArea(.all)
}
