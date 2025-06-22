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
            .bind(with: self) { _, _ in
                self.viewModel.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .bind(to: refreshController.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.bookmarkListRefresh)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchBookmarks()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] cell, indexPath in
                guard let self else { return }
                
                if indexPath.section + 1 == self.viewModel.bookmarks.value.count && self.viewModel.bookmarks.value.count >= 20 {
                    viewModel.fetchBookmarks()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.sortOption
            .bind(onNext: { [weak self] value in
                let ascendingAction = UIAction(
                    title: "오래된 순",
                    image: value == .createdAtAscending ? UIImage(systemName: "checkmark") : nil,
                    handler: { _ in
                        UserDefaults.standard.set(BookmarkSortOption.createdAtAscending.rawValue, forKey: UserDefaultsKeys.bookmarkSortOption.rawValue)
                        self?.viewModel.sortOption.accept(.createdAtAscending)
                    }
                )
                let descendingAction = UIAction(
                    title: "최신 순",
                    image: value == .createdAtDescending ? UIImage(systemName: "checkmark") : nil,
                    handler: { _ in
                        UserDefaults.standard.set(BookmarkSortOption.createdAtDescending.rawValue, forKey: UserDefaultsKeys.bookmarkSortOption.rawValue)
                        self?.viewModel.sortOption.accept(.createdAtDescending)
                    }
                )
                
                self?.menuBtn.menu = UIMenu(
                    identifier: nil,
                    options: .displayInline,
                    children: [descendingAction, ascendingAction]
                )
                
                self?.viewModel.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
