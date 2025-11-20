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

extension BookmarkTableViewController: ThirdTabNavigationItemConfigurable, SettingButtonConfigurable {
    func bind() {
        bindTableView()
        bindDeleteAction()
        bindRefreshControl()
        bindPagination()
        bindSortOption()
        bindSortOptionNotification()
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<BookmarkSectionModel>(
            animationConfiguration: AnimationConfiguration(deleteAnimation: .top)
        ) { data, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkListRow.reuseIdentifier, for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration { BookmarkListRow(bookmark: item) }
            
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
    }
    
    private func bindDeleteAction() {
        tableView.rx.itemDeleted
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, indexPath in
                let sections = owner.viewModel.bookmarks.value
                let bookmark = sections[indexPath.section].items[0]
                
                let alert = UIAlertController(
                    title: "북마크를 삭제할까요?",
                    message: bookmark.notice.title,
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "취소", style: .default))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                    owner.viewModel.delete(bookmark: bookmark)
                })
                
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshControl() {
        refreshController.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .bind(to: refreshController.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindPagination() {
        tableView.rx.willDisplayCell
            .subscribe(on: MainScheduler.instance)
            .bind(with: self) { owner, cell in
                if cell.indexPath.section + 1 == owner.viewModel.bookmarks.value.count && owner.viewModel.bookmarks.value.count >= 20 {
                    owner.viewModel.fetchBookmarks()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSortOption() {
        viewModel.$bookmarkSortOption
            .sink { [weak self] value in
                guard let self else { return }
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.makeBookmarkTitleBarItem()
                    self.navigationItem.rightBarButtonItems = [
                        self.settingBarButtonItem,
                        self.makeSortMenuButton(selectedOption: value)
                    ]
                }
                self.viewModel.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindSortOptionNotification() {
        NotificationCenter.default.publisher(for: .bookmarkSortOptionDidChange)
            .sink { [weak self] notification in
                guard
                    let option = notification.userInfo?[UserInfoKeys.bookmarkSortOption.rawValue] as? BookmarkSortOption
                else { return }
                
                self?.viewModel.bookmarkSortOption = option
            }
            .store(in: &cancellables)
    }
    
}
