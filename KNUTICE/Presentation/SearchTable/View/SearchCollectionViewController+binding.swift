//
//  SearchCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import RxDataSources
import RxSwift
import SwiftUI

extension SearchCollectionViewController: RxDataSourceProvidable {
    func bind() {
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)    //0.5초 대기
            .distinctUntilChanged()    //동일한 값은 무시
            .bind(with: self) { owner, keyword in
                if let viewModel = owner.viewModel as? Searchable, let keyword {
                    viewModel.search(keyword)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.notices
            .observe(on: MainScheduler.instance)
            .do { [weak self] in
                if let text = self?.searchBar.text, !text.isEmpty,
                   let result = $0.first, result.items.isEmpty == true {
                    self?.collectionView.backgroundView = UIHostingController(rootView: ResultNotFoundView()).view
                } else if let text = self?.searchBar.text, text.isEmpty {
                    self?.collectionView.backgroundView = UIHostingController(rootView: SearchCollectionViewBackground()).view
                } else {
                    self?.collectionView.backgroundView = nil
                }
            }
            .bind(to: collectionView.rx.items(dataSource: makeNoticeDataSource()))
            .disposed(by: disposeBag)
    }
}
