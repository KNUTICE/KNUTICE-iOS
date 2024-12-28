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
        tableView.backgroundColor = .customBackground
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 95        
        tableView.refreshControl = refreshControl
        
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "KNUTICE"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        
        navigationItem.leftBarButtonItems = [negativeSpacer, labelItem]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(navigateToSetting(_:))),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navigateToSearch(_:)))
        ]
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        //TableView Constraint
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
