//
//  BookmarkTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Foundation
import SwiftUI
import RxDataSources
import RxSwift
import UIKit

extension BookmarkTableViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<BookmarkSectionModel>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.reuseIdentifier, for: indexPath) as! BookmarkTableViewCell
            cell.configure(item)
            
            return cell
            
        })
        
        viewModel.bookmarks
            .observe(on: MainScheduler.instance)
            .skip(1)
            .do(onNext: { [weak self] bookmarks in
                if bookmarks.isEmpty {
                    let backgroundView = UIHostingController(rootView: EmptyBookmarkView())
                    self?.tableView.backgroundView = backgroundView.view
                    self?.tableView.tableHeaderView = nil
                }  else {
                    self?.tableView.backgroundView = nil
                    self?.tableView.tableHeaderView = self?.createTableHeaderView(text: "개수(\(bookmarks.count))")
                    self?.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
                }
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.fetchBookmarks(isRefreshing: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .bind(to: refreshController.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.bookmarkListRefresh)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchBookmarks()
            })
            .disposed(by: disposeBag)
    }
}
