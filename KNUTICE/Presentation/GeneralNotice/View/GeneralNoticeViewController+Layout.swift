//
//  GeneralNoticeViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/3/24.
//

import UIKit

extension GeneralNoticeViewController {
    func setupAttribute() {
        tableView.register(GeneralNoticeCell.self, forCellReuseIdentifier: GeneralNoticeCell.reuseIdentifier)    //reuseIndentifier 등록
        tableView.register(GeneralNoticeCellWithImage.self, forCellReuseIdentifier: GeneralNoticeCellWithImage.reuseIdentifier)
        tableView.estimatedRowHeight = 100    //동적 height 적용전 임시 값
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "일반소식"
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
