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
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 95        
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .mainBackground
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        //TableView Constraint
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
