//
//  Scrollable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/6/24.
//

import UIKit
import RxSwift

protocol Scrollable: AnyObject {
    var viewModel: NoticeTableViewModel { get }
    var tableView: UITableView { get }
    var disposeBag: DisposeBag { get }
    
    func bindWillDisplayCell()
}

extension Scrollable {
    private func createActivityIndicator() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        footerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(footerView)
        }
        
        return footerView
    }
    
    func bindWillDisplayCell() {
        tableView.rx.willDisplayCell
            .subscribe(on: MainScheduler.instance)    //Subscription Code가 수행될 스케줄러 지정
            .bind { [weak self] cell, indexPath in
                guard let self = self else { return }
                
                if indexPath.row == self.viewModel.noticesCount - 1 {
                    guard !(viewModel.isFetching.value) && !viewModel.isFinished.value else { return }
                    
                    tableView.tableFooterView = createActivityIndicator()
                    viewModel.fetchNextNotices()
                }
            }
            .disposed(by: disposeBag)
    }
}
