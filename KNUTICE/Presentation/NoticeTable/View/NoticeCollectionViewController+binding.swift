//
//  NoticeCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import UIKit
import RxCocoa
import RxDataSources

extension NoticeCollectionViewController: RxDataSourceProvidable {
    func bind() {        
        //MARK: - viewModel.notices
        viewModel.notices
            .skip(1)    //초기값은 무시
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                collectionView.backgroundView = nil
                
                if let viewModel = self.viewModel as? NoticeFetchable, viewModel.isRefreshing.value == false {
                    let offset = self.collectionView.contentOffset
                    self.collectionView.setContentOffset(offset, animated: false)
                }
            })
            .bind(to: collectionView.rx.items(dataSource: makeNoticeDataSource()))
            .disposed(by: disposeBag)
        
        //MARK: - collectionView.rx.willDisplayCell
        collectionView.rx.willDisplayCell
            .bind(with: self) { owner, cell in
                let (_, indexPath) = cell
                
                if let viewModel = owner.viewModel as? NoticeFetchable,
                   let count = owner.viewModel.notices.value.first?.items.count,
                   indexPath.item == count - 1 {
                    viewModel.fetchNextPage()
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: - viewModel.isRefreshing
        if let viewModel = viewModel as? NoticeFetchable {
            viewModel.isRefreshing
                .bind(to: refreshControl.rx.isRefreshing)
                .disposed(by: disposeBag)
        }
        
        //MARK: - refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                if let viewModel = self?.viewModel as? NoticeFetchable {
                    viewModel.fetchNotices(isRefreshing: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
