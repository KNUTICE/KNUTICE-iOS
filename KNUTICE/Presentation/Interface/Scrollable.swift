//
//  Scrollable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/6/24.
//

import UIKit
import RxSwift

protocol Scrollable {
    var viewModel: NoticeViewModel { get }
    var tableView: UITableView { get }
    var disposeBag: DisposeBag { get }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func createActivityIndicator() -> UIView
}

extension Scrollable {
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
