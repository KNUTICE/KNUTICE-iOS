//
//  BookmarkTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Foundation
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
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
