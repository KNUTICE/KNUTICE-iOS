//
//  SearchResultsTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/7/25.
//

import RxSwift
import UIKit
import SwiftUI

extension SearchResultsTableViewController {
    func bind() {
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)    //0.5초 대기
            .distinctUntilChanged()    //동일한 값은 무시
            .bind(onNext: { [weak self] keywork in
                guard let keyword = keywork else { return }
                self?.viewModel.search(keyword)
            })
            .disposed(by: disposeBag)
        
        viewModel.tableData
            .observe(on: MainScheduler.instance)
            .do { [weak self] in
                if let text = self?.searchBar.text, !text.isEmpty, $0.isEmpty {
                    self?.resultsTableView.backgroundView = UIHostingController(rootView: ResultNotFoundView()).view
                } else {
                    self?.resultsTableView.backgroundView = UIHostingController(rootView: SearchResultsBackgroundView()).view
                }
            }
            .bind(to: resultsTableView.rx.items) { tableView, row, item in
                if let imageURL = item.imageUrl {
                    let cell = tableView.dequeueReusableCell(withIdentifier: DetailedNoticeCellWithImage.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! DetailedNoticeCellWithImage
                    cell.titleLabel.text = item.title
                    cell.subTitleLabel.text = "[\(item.department)]"
                    cell.uploadDateLabel.text = item.uploadDate
                    cell.imageURL = imageURL
                    cell.backgroundColor = .detailViewBackground
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: DetailedNoticeCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! DetailedNoticeCell
                    cell.titleLabel.text = item.title
                    cell.subTitleLabel.text = "[\(item.department)]"
                    cell.uploadDateLabel.text = item.uploadDate
                    cell.backgroundColor = .detailViewBackground
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
}
