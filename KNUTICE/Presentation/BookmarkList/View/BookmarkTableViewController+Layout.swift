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
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(44)
        }
        
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(navigationBar.snp.leading).offset(16)
        }
        
        navigationBar.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func createTableHeaderView(text: String) -> UIView {
        let headerView = {
            let view = UIView()
            
            return view
        }()
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.text = text
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .gray
            
            return label
        }()
        
        
        headerView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(44)
        }
        
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(19)
        }
        
        return headerView
    }
}
