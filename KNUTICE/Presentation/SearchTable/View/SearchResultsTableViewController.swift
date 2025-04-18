//
//  SearchResultsTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 4/18/25.
//

import UIKit
import SwiftUI

@available(iOS 18, *)
final class SearchResultsTableViewController: UIViewController {
    let resultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureNavigationItems()
    }
}

@available(iOS 18, *)
extension SearchResultsTableViewController {
    func configureNavigationItems() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
    }
}

@available(iOS 18, *)
extension SearchResultsTableViewController {
    func setupLayout() {
        view.addSubview(resultsTableView)
        resultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#Preview {
    if #available(iOS 18, *) {
        let navigationController = UINavigationController(rootViewController: SearchResultsTableViewController())
        navigationController
            .makePreview()
    }
}
