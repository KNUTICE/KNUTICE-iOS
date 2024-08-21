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
    
    func setupAttribute() {
        view.backgroundColor = .white
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        navigationItem.largeTitleDisplayMode = .never    //navigation inline title
        progressView.progressTintColor = UIColor(red: 0 / 255, green: 132 / 255, blue: 255 / 255, alpha: 1.0)
        webView.isHidden = true
    }
    
    func setupLayout() {        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressView)
        view.addSubview(webView)
        view.backgroundColor = .customBackground
        
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(openSharePanel))
    }
}
