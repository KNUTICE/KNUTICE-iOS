//
//  SearchCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import RxDataSources
import RxSwift
import SwiftUI

extension SearchCollectionViewController {
    func bind() {
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)    //0.5초 대기
            .distinctUntilChanged()    //동일한 값은 무시
            .bind(onNext: { [weak self] keywork in
                guard let keyword = keywork else { return }
                self?.viewModel.search(keyword)
            })
            .disposed(by: disposeBag)
        
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
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
