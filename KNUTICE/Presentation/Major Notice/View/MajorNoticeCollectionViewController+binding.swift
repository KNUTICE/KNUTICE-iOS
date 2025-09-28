//
//  MajorNoticeCollectionViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/26/25.
//

import Foundation

extension MajorNoticeCollectionViewController {    
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
    }
}
