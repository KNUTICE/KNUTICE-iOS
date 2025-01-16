//
//  SearchTableViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import UIKit

extension SearchTableViewController {
    //MARK: - Setup Navigation Bar
    func setUpNavigationBar() {
        //SearchBar
        searchBar.placeholder = "공지사항 검색"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        //Cancel Button
        let cancelButton = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    //MARK: - Setup UITableView Background View
    func setUpBackgroundView() {
        let backgroundView = UIView()
        backgroundView.frame = tableView.bounds // tableView 크기에 맞춤
        
        let textView = UITextView()
        textView.text = "검색결과가 없어요 :("
        textView.isScrollEnabled = false
        textView.textColor = .gray
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.backgroundColor = .detailViewBackground
        
        backgroundView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.backgroundView = backgroundView
    }
}

extension SearchTableViewController {
    //MARK: - Closs Button Call Back Function
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}
