//
//  RxDataSourceProvidable.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import RxDataSources
import RxSwift
import UIKit

@MainActor
protocol RxDataSourceBindable: AnyObject {
    var collectionView: UICollectionView { get }
    var viewModel: NoticeSectionModelProvidable { get }
    var disposeBag: DisposeBag { get }
    
    func bindNotices()
}

extension RxDataSourceBindable {
    func bindNotices() {
        viewModel.notices
            .skip(1)
            .do(onNext: { [weak self] notices in
                guard let self, !notices.isEmpty else { return }
                
                collectionView.backgroundView = nil
                
                if let viewModel = self.viewModel as? NoticeFetchable, viewModel.isRefreshing.value == false {
                    let offset = self.collectionView.contentOffset
                    self.collectionView.setContentOffset(offset, animated: false)
                }
            })
            .bind(to: collectionView.rx.items(dataSource: makeNoticeDataSource()))
            .disposed(by: disposeBag)
    }
    
    func makeNoticeDataSource() -> RxCollectionViewSectionedReloadDataSource<NoticeSectionModel> {
        RxCollectionViewSectionedReloadDataSource<NoticeSectionModel>(configureCell: { [weak self] (dataSource, collectionView, indexPath, item) in
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
    }
    
}
