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
public protocol RxDataSourceBindable: AnyObject {
    associatedtype T: NoticeSectionModelProvidable
    
    var collectionView: UICollectionView { get }
    var viewModel: T { get }
    var disposeBag: DisposeBag { get }
    
    func bindNotices()
}

public extension RxDataSourceBindable {
    func bindNotices() {
        viewModel.notices
            .skip(1)
            .do(onNext: { [weak self] notices in
                guard let self, !notices.isEmpty else { return }
                
                collectionView.backgroundView = nil
            })
            .bind(to: collectionView.rx.items(dataSource: makeNoticeDataSource()))
            .disposed(by: disposeBag)
    }
    
    func makeNoticeDataSource() -> RxCollectionViewSectionedAnimatedDataSource<NoticeSectionModel> {
        RxCollectionViewSectionedAnimatedDataSource<NoticeSectionModel>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .none,
                reloadAnimation: .none,
                deleteAnimation: .none
            ),
            configureCell: { [weak self] (dataSource, collectionView, indexPath, item) in
                guard let self else {
                    return UICollectionViewCell()
                }
                
                let shouldUseThumbnail: Bool = {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        return item.notice.imageURL != nil
                    } else {
                        if item.notice.imageURL != nil { return true }
                        
                        let items = self.viewModel.notices.value[0].items
                        let count = self.viewModel.notices.value[0].items.count
                        
                        if indexPath.row % 2 == 0 {    //짝수번째 cell
                            let next = indexPath.row + 1
                            return 0..<count ~= next && items[next].notice.imageURL != nil
                        } else {    //홀수번째 cell
                            let before = indexPath.row - 1
                            return 0..<count ~= before && items[before].notice.imageURL != nil
                        }
                    }
                }()
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCollectionViewCell.reuseIdentifier, for: indexPath) as! NoticeCollectionViewCell
                
                cell.configure(with: item, isShowingThumbnail: shouldUseThumbnail)
                return cell
            }
        )
    }
    
}
