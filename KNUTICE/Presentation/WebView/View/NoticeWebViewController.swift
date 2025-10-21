//
//  NoticeWebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import UIKit
import WebKit

class NoticeWebViewController: UIViewController {
    let activityIndicator: UIActivityIndicatorView = {
        let activitiyIndicator = UIActivityIndicatorView(style: .large)
        activitiyIndicator.startAnimating()
        activitiyIndicator.hidesWhenStopped = true
        
        return activitiyIndicator
    }()
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.isHidden = true
        
        return webView
    }()
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        
        // MARK: - Configure symbol image
        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        
        // MARK: - Base appearance
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .zero
        button.addTarget(self, action: #selector(openBookmarkForm(_:)), for: .touchUpInside)
        
        // MARK: - Style
        if #available(iOS 26, *) {
            button.configuration = .glass()
        } else {
            button.backgroundColor = .accent2
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLayout()
        setupNavigationBar()
        view.backgroundColor = .detailViewBackground
    }
    
    private func setupLayout() {
        //webView
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //bookmarkBtn
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(UIDevice.current.userInterfaceIdiom == .phone ? -50 : -100)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "알림", message: "공유를 완료했어요.", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
}

extension NoticeWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.isHidden = true
        
        webView.evaluateJavaScript(
            """
            document.documentElement.style.webkitUserSelect='none';
            document.documentElement.style.webkitTouchCallout='none';
            document.getElementById(\"header\").style.display='none';
            document.getElementById(\"footer\").style.display='none';
            document.getElementById(\"remote\").style.display='none';
            """
        ) { (res, error) -> Void in
            //로딩 완료 후 webView 활성화
            webView.isHidden = false
            
            if let error {
                print("WebViewController error: \(error.localizedDescription)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let aString = URL(string:(navigationAction.request.url?.absoluteString ?? "")) {
            UIApplication.shared.open(aString, options:[:]) { _ in }
        }
        
        return nil
    }
}

extension NoticeWebViewController {
    @objc func openBookmarkForm(_ sender: UIButton) {
        fatalError("openBookmarkForm(_:) must be overridden by subclass")
    }
}

extension NoticeWebViewController {
    func setupNavigationBar() {
        //NavigationItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(openSharePanel)
        )
    }
    
    @objc func openSharePanel() {
        fatalError("openBookmarkForm(_:) must be overridden by subclass")
    }
}
