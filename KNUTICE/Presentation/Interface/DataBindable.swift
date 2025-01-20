//
//  DataBindable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import RxSwift

protocol DataBindable: AnyObject {
    var viewModel: NoticeViewModel { get }
    var tableView: UITableView { get }
    var refreshControl: UIRefreshControl { get }
    var disposeBag: DisposeBag { get }
    
    func bind()
    func bindFetchingState()
}

extension DataBindable {
    func bind() {
        viewModel.noticesObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, row, item in
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
    
    func bindFetchingState() {
        viewModel.isFetchingObservable
            .subscribe(onNext: { [weak self] isFetching in
                if let self, !isFetching {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UIView.animate(withDuration: 0.5) {
                            self.tableView.tableFooterView = nil
                        }
                    }
                    
                    if viewModel.isFinished.value {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            UIView.animate(withDuration: 2) {
                                self.viewModel.notices.accept(self.viewModel.notices.value)
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindRefreshingState() {
        viewModel.isRefreshing
            .observe(on: MainScheduler.instance)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.viewModel.refreshNotices()
            })
            .disposed(by: disposeBag)
    }
}
