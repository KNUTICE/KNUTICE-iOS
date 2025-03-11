//
//  WebViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit

extension WebViewController {
    func loadPage(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
    
    func setupLayout() {
        view.backgroundColor = .detailViewBackground
        
        //progressView
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        //webView
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //reminderSheetBtn
        view.addSubview(reminderSheetBtn)
        reminderSheetBtn.translatesAutoresizingMaskIntoConstraints = false
        reminderSheetBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(openSharePanel))
    }
}
