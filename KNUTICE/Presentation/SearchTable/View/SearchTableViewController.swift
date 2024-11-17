//
//  SearchTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import UIKit
import SwiftUI
import RxSwift

final class SearchTableViewController: UIViewController, TableViewConfigurable {
    let tableView = UITableView(frame: .zero, style: .grouped)
    let searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()    //protocol 요구사항 구현
    let viewModel: SearchTableViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: SearchTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        setupLayout()
        setupAttribute(showRefreshControl: false)
        setUpNavigationBar()
        bindWithSearchBar()
        bindWithTableView()
        tableView.contentInset = UIEdgeInsets(top: -34, left: 0, bottom: 0, right: 0);    //상단 빈 공간 제거
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()    //키보드 자동 활성화
    }
}

extension SearchTableViewController: UITableViewDelegate {
}

#if DEBUG
struct SearchTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: SearchTableViewController(viewModel: AppDI.shared.makeSearchTableViewModel()))
            .makePreview()
    }
}
#endif
