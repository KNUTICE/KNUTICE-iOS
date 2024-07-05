//
//  MainViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import UIKit
import SwiftUI

//MARK: - Layout
extension MainViewController {
    func setupAttribute() {
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 95
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "KNUTICE"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        
        navigationItem.leftBarButtonItems = [negativeSpacer, labelItem]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill")?.withTintColor(.navigationItemGray, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(navigateToSetting(_:)))
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
