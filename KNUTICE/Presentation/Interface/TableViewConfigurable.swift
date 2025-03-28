//
//  TableViewConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit

protocol TableViewConfigurable: UIViewController {
    var tableView: UITableView { get }
    var refreshControl: UIRefreshControl { get }
    
    func setupAttribute(showRefreshControl: Bool)
    func setupNavigationBar(title: String)
    func setupLayout()
}

extension TableViewConfigurable {
    func setupAttribute(showRefreshControl: Bool) {
        tableView.register(DetailedNoticeCell.self, forCellReuseIdentifier: DetailedNoticeCell.reuseIdentifier)    //reuseIndentifier 등록
        tableView.register(DetailedNoticeCellWithImage.self, forCellReuseIdentifier: DetailedNoticeCellWithImage.reuseIdentifier)
        tableView.estimatedRowHeight = 100    //동적 height 적용전 임시 값
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .detailViewBackground
        
        if showRefreshControl {
            tableView.refreshControl = refreshControl
        }
    }
    
    func setupNavigationBar(title: String) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = title
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func setActivityIndicator() {
        let spinner = UIActivityIndicatorView(style: .large)
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
}
