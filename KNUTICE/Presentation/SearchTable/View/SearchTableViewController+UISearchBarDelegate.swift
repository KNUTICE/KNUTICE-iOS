//
//  SearchTableViewController+UISearchBarDelegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/8/24.
//

import UIKit

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
