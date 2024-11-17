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
}

extension SearchTableViewController {
    //MARK: - Closs Button Call Back Function
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}
