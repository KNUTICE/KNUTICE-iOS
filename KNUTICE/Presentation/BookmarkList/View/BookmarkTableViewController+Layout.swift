//
//  BookmarkTableViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Foundation
import UIKit

extension BookmarkTableViewController {
    func setUpLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
