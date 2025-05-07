//
//  SearchResultsTableViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/7/25.
//

import UIKit

extension SearchResultsTableViewController {
    func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.trailing)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
        
        view.addSubview(resultsTableView)
        resultsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    func updateSearchBarConstraints(isShowCancelButton: Bool) {
        searchBar.snp.removeConstraints()
        cancelButton.snp.removeConstraints()
        
        if isShowCancelButton {
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.trailing.equalToSuperview().offset(-10)
                make.centerY.equalTo(searchBar.snp.centerY)
            }
            
            searchBar.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalTo(cancelButton.snp.leading)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        } else {
            cancelButton.snp.makeConstraints { make in
                make.leading.equalTo(view.snp.trailing)
                make.centerY.equalTo(searchBar.snp.centerY)
            }
            
            searchBar.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
