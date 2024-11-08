//
//  SearchTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/8/24.
//

import RxCocoa
import RxSwift

extension SearchTableViewController {
    func bindWithSearchBar() {
        searchBar.searchTextField.rx.text
            .debounce(.seconds(2), scheduler: MainScheduler.instance)    //2초 동안 debounce
            .distinctUntilChanged()    //동일한 값의 방출은 무시
            .bind(onNext: { [weak self] keyword in
                guard let keyword = keyword else { return }
                self?.viewModel.search(keyword)
            })
            .disposed(by: disposeBag)
    }
    
    func bindWithTableView() {
        viewModel.searchedNotices
        .observe(on: MainScheduler.instance)
        .bind(to: tableView.rx.items) { tableView, row, item in
            if let imageURL = item.imageUrl {
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailedNoticeCellWithImage.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! DetailedNoticeCellWithImage
                cell.titleLabel.text = item.title
                cell.subTitleLabel.text = "[\(item.department)]"
                cell.uploadDateLabel.text = item.uploadDate
                cell.imageURL = imageURL
                cell.backgroundColor = .customBackground
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailedNoticeCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! DetailedNoticeCell
                cell.titleLabel.text = item.title
                cell.subTitleLabel.text = "[\(item.department)]"
                cell.uploadDateLabel.text = item.uploadDate
                cell.backgroundColor = .customBackground
                
                return cell
            }
        }
        .disposed(by: disposeBag)
    }
    
}
