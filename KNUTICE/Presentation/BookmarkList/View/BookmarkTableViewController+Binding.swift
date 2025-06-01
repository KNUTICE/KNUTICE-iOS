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
        let dataSource = RxTableViewSectionedAnimatedDataSource<BookmarkSectionModel>(
            animationConfiguration: AnimationConfiguration(deleteAnimation: .top)
        ) { data, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.reuseIdentifier, for: indexPath) as! BookmarkTableViewCell
            cell.configure(item)
            
            return cell
        }
        dataSource.canEditRowAtIndexPath = { _, _ in true }
        
        viewModel.bookmarks
            .observe(on: MainScheduler.instance)
            .skip(1)
            .do(onNext: { [weak self] bookmarks in
                if bookmarks.isEmpty {
                    let backgroundView = UIHostingController(rootView: EmptyBookmarkView())
                    self?.tableView.backgroundView = backgroundView.view
                }  else {
                    self?.tableView.backgroundView = nil
                }
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, indexPath in
                let sections = owner.viewModel.bookmarks.value
                let bookmark = sections[indexPath.section].items[0]
                owner.viewModel.delete(bookmark: bookmark)
            })
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
