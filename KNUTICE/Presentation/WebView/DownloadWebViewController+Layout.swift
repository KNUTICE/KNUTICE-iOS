//
//  DownloadWebViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/11/24.
//

import Foundation

extension DownloadWebViewController {
    func loadPage(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
    
    func setupAttribute() {
        view.backgroundColor = .white
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        navigationItem.largeTitleDisplayMode = .never    //navigation inline title
    }
    
    func setupLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        view.backgroundColor = .customBackground
        
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
