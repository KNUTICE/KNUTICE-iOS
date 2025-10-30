//
//  SearchCollectionViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import UIKit

extension SearchViewController {
    func setupLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.trailing)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(30)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
        }
        
        view.addSubview(bookmarkTableView)
        bookmarkTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
        }
    }
    
    func updateSearchBarConstraints(isShowCancelButton: Bool) {
        if isShowCancelButton {
            cancelButton.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
                make.centerY.equalTo(searchBar.snp.centerY)
            }
            
            searchBar.snp.remakeConstraints { make in
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.trailing.equalTo(cancelButton.snp.leading).offset(10)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        } else {
            cancelButton.snp.remakeConstraints { make in
                make.leading.equalTo(view.snp.trailing)
                make.centerY.equalTo(searchBar.snp.centerY)
            }
            
            searchBar.snp.remakeConstraints { make in
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
