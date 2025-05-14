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
        
        viewModel.notices
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
