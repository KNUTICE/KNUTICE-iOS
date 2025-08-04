//
//  SearchCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import RxDataSources
import RxSwift
import SwiftUI

extension SearchViewController: RxDataSourceProvidable {
    func bind() {
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)    //0.5초 대기
            .distinctUntilChanged()    //동일한 값은 무시
            .bind(with: self) { owner, keyword in
                if let viewModel = owner.viewModel as? Searchable, let keyword {
                    viewModel.search(with: keyword)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.notices
            .observe(on: MainScheduler.instance)
            .do { [weak self] in
                if let text = self?.searchBar.text, !text.isEmpty,
                   let result = $0.first, result.items.isEmpty == true {
                    self?.collectionView.backgroundView = UIHostingController(rootView: ResultNotFoundView()).view
                } else if let text = self?.searchBar.text, text.isEmpty {
                    self?.collectionView.backgroundView = UIHostingController(rootView: SearchViewBackground(style: .notice)).view
                } else {
                    self?.collectionView.backgroundView = nil
                }
            }
            .bind(to: collectionView.rx.items(dataSource: makeNoticeDataSource()))
            .disposed(by: disposeBag)
        
        if let viewModel = viewModel as? SearchViewModel {
            viewModel.bookmarks
                .observe(on: MainScheduler.instance)
                .do { [weak self] in
                    if let text = self?.searchBar.text, !text.isEmpty, $0.isEmpty {
                        self?.bookmarkTableView.backgroundView = UIHostingController(rootView: ResultNotFoundView()).view
                    } else if let text = self?.searchBar.text, text.isEmpty {
                        self?.bookmarkTableView.backgroundView = UIHostingController(rootView: SearchViewBackground(style: .bookmark)).view
                    } else {
                        self?.bookmarkTableView.backgroundView = nil
                    }
                }
                .bind(to: bookmarkTableView.rx.items) { tableView, row, item in
                    let cell = self.bookmarkTableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! BookmarkTableViewCell
                    cell.configure(item)
                    cell.backgroundColor = .clear
                    
                    return cell
                }
                .disposed(by: disposeBag)
        }
    }
}
