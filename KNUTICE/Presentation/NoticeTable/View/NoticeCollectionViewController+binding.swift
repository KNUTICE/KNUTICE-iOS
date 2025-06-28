//
//  NoticeCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import UIKit
import RxCocoa
import RxDataSources

extension NoticeCollectionViewController {
    func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<NoticeSectionModel>(configureCell: { [weak self] (dataSource, collectionView, indexPath, item) in
            guard let self else {
                return UICollectionViewCell()
            }
            
            let shouldUseThumbnail: Bool = {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    return item.imageUrl != nil
                } else {
                    if item.imageUrl != nil { return true }
                    
                    let items = self.viewModel.notices.value[0].items
                    let count = self.viewModel.notices.value[0].items.count
                    
                    if indexPath.row % 2 == 0 {    //짝수번째 cell
                        let next = indexPath.row + 1
                        return 0..<count ~= next && items[next].imageUrl != nil
                    } else {    //홀수번째 cell
                        let before = indexPath.row - 1
                        return 0..<count ~= before && items[before].imageUrl != nil
                    }
                }
            }()
            
            if shouldUseThumbnail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCollectionViewCellWithThumbnail.reuseIdentifier, for: indexPath) as! NoticeCollectionViewCellWithThumbnail
                cell.imageURL = ""
                cell.configure(with: item)
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier, for: indexPath) as! NoticeCollectionViewCell
            cell.configure(with: item)
            
            return cell
        })
        
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
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //MARK: - collectionView.rx.willDisplayCell
        collectionView.rx.willDisplayCell
            .bind { [weak self] cell, indexPath in
                guard let self else { return }
                
                if let viewModel = self.viewModel as? NoticeFetchable,
                   let valuesCount = self.viewModel.notices.value.first?.items.count,
                   indexPath.item == valuesCount - 1 {
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
