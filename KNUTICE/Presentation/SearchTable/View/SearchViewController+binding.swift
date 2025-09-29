//
//  SearchCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import RxDataSources
import RxSwift
import RxCocoa
import SwiftUI

extension SearchViewController: RxDataSourceBindable {
    func bind() {
        bindNotices()
        bindSearchBar()
        bindBookmarks()
    }

    // MARK: - Private Bindings
    private func bindSearchBar() {
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)    // 0.5초 대기
            .distinctUntilChanged()    // 동일한 값은 무시
            .bind(with: self) { owner, keyword in
                if let viewModel = owner.viewModel as? Searchable, let keyword {
                    viewModel.search(with: keyword)
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindBookmarks() {
        guard let viewModel = viewModel as? Searchable else { return }

        viewModel.bookmarks
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] items in
                self?.updateBookmarkBackground(forResultsEmpty: items.isEmpty)
            })
            .bind(to: bookmarkTableView.rx.items(
                cellIdentifier: BookmarkTableViewCell.reuseIdentifier,
                cellType: BookmarkTableViewCell.self
            )) { _, item, cell in
                cell.configure(item)
                cell.backgroundColor = .clear
            }
            .disposed(by: disposeBag)
    }

    private func updateBookmarkBackground(forResultsEmpty isEmptyResults: Bool) {
        let text = searchBar.text ?? ""

        if !text.isEmpty && isEmptyResults {
            bookmarkTableView.backgroundView = UIHostingController(rootView: ResultNotFoundView()).view
        } else if text.isEmpty {
            bookmarkTableView.backgroundView = UIHostingController(rootView: SearchViewBackground(style: .bookmark)).view
        } else {
            bookmarkTableView.backgroundView = nil
        }
    }
}
