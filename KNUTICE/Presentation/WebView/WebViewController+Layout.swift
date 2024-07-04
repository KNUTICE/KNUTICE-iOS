//
//  WebViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import Foundation

extension WebViewController {
    func loadPage(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
    
    func setupAttribute() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        navigationItem.largeTitleDisplayMode = .never    //navigation inline title
    }
    
    func setupLayout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}
