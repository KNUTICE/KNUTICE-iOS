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
    let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = .accent2
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.isHidden = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    lazy var reminderSheetBtn: UIButton = {
        let button = UIButton()
        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        button.setImage(plusImage, for: .highlighted)
        button.tintColor = .white
        button.backgroundColor = .accent2
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(openBookmarkForm(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let notice: Notice
    
    init(notice: Notice) {
        self.notice = notice
        
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
        
        navigationItem.largeTitleDisplayMode = .never    //navigation inline title
        view.backgroundColor = .detailViewBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(openSharePanel))
        setupLayout()
        loadPage(notice.contentUrl)
    }
    
    private func loadPage(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
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
        webView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let aString = URL(string:(navigationAction.request.url?.absoluteString ?? "")) {
            UIApplication.shared.open(aString, options:[:]) { _ in }
        }
        
        return nil
    }
}

extension WebViewController {
    func setupLayout() {
        //progressView
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        //webView
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //reminderSheetBtn
        view.addSubview(reminderSheetBtn)
        reminderSheetBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }
    }
}

extension WebViewController {
    @objc func openSharePanel() {
        let shareText = self.notice.contentUrl
        let shareObject = [shareText]
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.showCompletionAlert()
            } else {
                
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func showCompletionAlert() {
        let alert = UIAlertController(title: "알림", message: "공유를 완료했어요.", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func openBookmarkForm(_ sender: UIButton) {
        let bookmarkForm = BookmarkForm(viewModel: BookmarkFormViewModel(), notice: self.notice) {
            self.dismiss(animated: true)
        }
        let viewController = UIHostingController(rootView: bookmarkForm)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }
}

#if DEBUG
//MARK: - Preview
struct WebViewControllerPreview: PreviewProvider {
    static var previews: some View {
        WebViewController(notice: Notice.generalNoticesSampleData.first!)
            .makePreview()
    }
}
#endif
