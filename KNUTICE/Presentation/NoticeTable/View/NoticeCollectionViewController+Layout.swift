//
//  NoticeCollectionViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/7/25.
//

import Foundation

extension NoticeCollectionViewController {
    func setUpLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpNavigationBar(title: String) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = title
    }
}
