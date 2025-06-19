//
//  SearchCollectionViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import UIKit

extension SearchCollectionViewController {
    func setupLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.trailing)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
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
                make.trailing.equalToSuperview()
                make.centerY.equalTo(searchBar.snp.centerY)
            }
            
            searchBar.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalTo(cancelButton.snp.leading).offset(10)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        } else {
            cancelButton.snp.makeConstraints { make in
                make.leading.equalTo(view.snp.trailing)
                make.centerY.equalTo(searchBar.snp.centerY)
            }
            
            searchBar.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
