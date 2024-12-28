//
//  SearchTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/8/24.
//

import RxSwift

extension SearchTableViewController {
    func bindWithSearchBar() {
        searchBar.searchTextField.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)    //1초 동안 debounce
            .distinctUntilChanged()    //동일한 값의 방출은 무시
            .bind(onNext: { [weak self] keyword in
                guard let keyword = keyword else { return }
                self?.viewModel.search(keyword)
            })
            .disposed(by: disposeBag)
    }
    
    func bindWithTableView() {
        viewModel.tableData
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
    
    func bindWithBackgroundView() {
        viewModel.notices
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let notices = $0 else {
                    self?.tableView.backgroundView?.isHidden = true    //notice가 nil인 경우 backgroundView 숨김
                    return
                }
                
                self?.tableView.backgroundView?.isHidden = !notices.isEmpty ? true : false
            })
            .disposed(by: disposeBag)
    }
    
}
