//
//  MainViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import UIKit

//MARK: - Layout
extension MainViewController {
    func setupAttribute() {
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 95
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        //TableView Constraint
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        let bannerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bannerView.backgroundColor = .lightGray
        bannerView.layer.cornerRadius = 10
        
        let bannerContainerView = UIView()
        bannerContainerView.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        }
        
        bannerContainerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        tableView.tableHeaderView = bannerContainerView
        
        let label = UILabel()
        label.text = "광고 자리"
        label.font = UIFont.systemFont(ofSize: 20)
        label.tintColor = .black
        bannerView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
}
