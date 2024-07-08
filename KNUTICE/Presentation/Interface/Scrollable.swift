//
//  Scrollable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/6/24.
//

import UIKit
import RxSwift

protocol Scrollable: AnyObject {
    var viewModel: NoticeViewModel { get }
    var tableView: UITableView { get }
    var disposeBag: DisposeBag { get }
    
    func bindFetchingState()
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func createActivityIndicator() -> UIView
}

extension Scrollable {
    func bindFetchingState() {
        viewModel.isFetchingObservable
            .subscribe(onNext: { [weak self] isFetching in
                if !isFetching {
                    self?.tableView.tableFooterView = nil
                }
            })
            .disposed(by: disposeBag)
    }
    
    func createActivityIndicator() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        footerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(footerView)
        }
        
        return footerView
    }
}
