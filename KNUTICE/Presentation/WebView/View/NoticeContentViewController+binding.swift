//
//  NoticeContentViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import Foundation

extension NoticeContentViewController {
    func bind() {
        viewModel.$notice
            .dropFirst()
            .sink(receiveValue: { [weak self] notice in
                guard let notice, let url = URL(string: notice.contentUrl) else { return }
                
                self?.webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
            })
            .store(in: &cancellables)
    }
}
