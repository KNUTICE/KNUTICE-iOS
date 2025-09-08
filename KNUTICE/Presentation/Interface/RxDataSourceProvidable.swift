//
//  RxDataSourceProvidable.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import UIKit
import RxDataSources

protocol RxDataSourceProvidable: AnyObject {
    var collectionView: UICollectionView { get }
    var viewModel: NoticeSectionModelProvidable { get }
    
    func makeNoticeDataSource() -> RxCollectionViewSectionedReloadDataSource<NoticeSectionModel>
}

extension RxDataSourceProvidable {
    @MainActor
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
