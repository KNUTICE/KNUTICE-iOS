//
//  MajorNoticeCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/26/25.
//

import Foundation

extension MajorNoticeCollectionViewController: RxDataSourceProvidable {    
    func bind() {
        if let viewModel = viewModel as? MajorNoticeCollectionViewModel {
            viewModel.$selectedMajor
                .sink(receiveValue: { [weak self] in
                    self?.titleButton.configuration?.title = $0?.localizedDescription ?? "학과명"
                    
                    if let selectedMajor = $0 {
                        viewModel.fetchNotices()
                        UserDefaults.standard.set(selectedMajor.rawValue, forKey: UserDefaultsKeys.selectedMajor.rawValue)
                    }
                })
                .store(in: &cancellables)
        }
        
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
    }
}
