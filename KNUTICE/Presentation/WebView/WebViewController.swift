//
//  WebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit
import WebKit
import SwiftUI
import Foundation

final class WebViewController: UIViewController {
    let progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)
    let webView: WKWebView = WKWebView()
    let reminderSheetBtn: UIButton = UIButton()
    let notice: Notice
    let isBookmarkBtnVisible: Bool
    
    init(notice: Notice, isBookmarkBtnVisible: Bool) {
        self.notice = notice
        self.isBookmarkBtnVisible = isBookmarkBtnVisible
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttribute()
        setupNavigationBarItem()
        setupLayout()
        loadPage(notice.contentUrl)
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressView.progress = Float(Double(webView.estimatedProgress))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.progress = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.isHidden = true
        }
        
        //롱터치 방지
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none'", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none'", completionHandler: nil)
        
        //Header와 Footer 숨김
        webView.evaluateJavaScript("document.getElementById(\"header\").style.display='none';document.getElementById(\"footer\").style.display='none';", completionHandler: { (res, error) -> Void in
            if let error {
                print("WebViewController error: \(error.localizedDescription)")
            }
        })
        
        //로딩 완료 후 webView 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            webView.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let aString = URL(string:(navigationAction.request.url?.absoluteString ?? "")) {
            UIApplication.shared.open(aString, options:[:]) { _ in }
        }
        
        return nil
    }
}

#if DEBUG
//MARK: - Preview
struct WebViewControllerPreview: PreviewProvider {
    static var previews: some View {
        WebViewController(notice: Notice.generalNoticesSampleData.first!,
                          isBookmarkBtnVisible: true)
            .makePreview()
    }
}
#endif
