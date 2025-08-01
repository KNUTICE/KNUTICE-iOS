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
            .bind(with: self) { owner, indexPath in
                let sections = owner.viewModel.bookmarks.value
                let bookmark = sections[indexPath.section].items[0]
                let alert = UIAlertController(title: "북마크를 삭제할까요?", message: bookmark.notice.title, preferredStyle: .alert)
                let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    owner.viewModel.delete(bookmark: bookmark)
                }
                let cancel = UIAlertAction(title: "취소", style: .default)
                
                alert.addAction(cancel)
                alert.addAction(delete)
                owner.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing
            .bind(to: refreshController.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.bookmarkRefresh)
            .bind(with: self) { owner, _ in
                owner.viewModel.reloadData()
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.bookmarkReload)
            .bind(with: self) { owner, _ in
                owner.viewModel.reloadData(preserveCount: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(on: MainScheduler.instance)
            .bind(with: self) { owner, cell in
                if cell.indexPath.section + 1 == owner.viewModel.bookmarks.value.count && owner.viewModel.bookmarks.value.count >= 20 {
                    owner.viewModel.fetchBookmarks()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.sortOption
            .bind(with: self) { owner, value in
                owner.menuBtn.menu = owner.makeSortMenu(selectedOption: value)
                owner.viewModel.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func makeSortMenu(selectedOption: BookmarkSortOption) -> UIMenu {
        func makeAction(title: String, option: BookmarkSortOption) -> UIAction {
            return UIAction(
                title: title,
                image: selectedOption == option ? UIImage(systemName: "checkmark") : nil,
                handler: { [weak self] _ in
                    UserDefaults.standard.set(option.rawValue, forKey: UserDefaultsKeys.bookmarkSortOption.rawValue)
                    self?.viewModel.sortOption.accept(option)
                }
            )
        }
        
        let actions = [
            makeAction(title: "오래된 생성일", option: .createdAtAscending),
            makeAction(title: "최근 생성일", option: .createdAtDescending),
            makeAction(title: "오래된 수정일", option: .updatedAtAscending),
            makeAction(title: "최근 수정일", option: .updatedAtDescending)
        ]
        
        return UIMenu(
            title: "북마크 정렬",
            identifier: nil,
            options: .displayInline,
            children: actions
        )
    }
}
