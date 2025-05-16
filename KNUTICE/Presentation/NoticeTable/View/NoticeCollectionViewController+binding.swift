//
//  NoticeCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import RxCocoa
import RxDataSources

extension NoticeCollectionViewController {
    func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<NoticeSectionModel>(configureCell: { (dataSource, collectionView, indexPath, item) in
            if let _ = item.imageUrl {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCellWithThumbnail.reuseIdentifier, for: indexPath) as! NoticeCellWithThumbnail
                cell.configure(with: item)
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCell.reuseIdentifier, for: indexPath) as! NoticeCell
            cell.configure(with: item)
            
            return cell
        })
        
        //MARK: - viewModel.notices
        viewModel.notices
            .skip(1)    //초기값은 무시
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                collectionView.backgroundView = nil
                
                if self.viewModel.isRefreshing.value == false {
                    let offset = self.collectionView.contentOffset
                    self.collectionView.setContentOffset(offset, animated: false)
                }
            })
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //MARK: - collectionView.rx.willDisplayCell
        collectionView.rx.willDisplayCell
            .bind { [weak self] cell, indexPath in
                guard let self else { return }
                
                if let valuesCount = self.viewModel.notices.value.first?.items.count,
                   indexPath.item == valuesCount - 1 {
                    self.viewModel.fetchNextPage()
                }
                
            }
            .disposed(by: disposeBag)
        
        //MARK: - viewModel.isRefreshing
        viewModel.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        //MARK: - refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.fetchNotices(isRefreshing: true)
            })
            .disposed(by: disposeBag)
    }
}
