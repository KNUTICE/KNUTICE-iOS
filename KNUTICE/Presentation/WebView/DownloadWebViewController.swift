//
//  DownloadWebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/11/24.
//

import UIKit
import WebKit

final class DownloadWebViewController: UIViewController {
    let webView: WKWebView = WKWebView()
    let url: String
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttribute()
        setupLayout()
        loadPage(url)
    }
}

extension DownloadWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let alert = UIAlertController(title: "알림", message: "파일을 다운로드 할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            decisionHandler(.download)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
            decisionHandler(.cancel)
            self.dismiss(animated: true)
        })
        
        self.present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
        
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
}
