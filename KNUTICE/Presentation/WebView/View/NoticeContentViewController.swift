//
//  NoticeWebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import Combine
import UIKit
import WebKit

final class NoticeContentViewController: UIViewController {
    private let activityIndicator: UIActivityIndicatorView = {
        let activitiyIndicator = UIActivityIndicatorView(style: .large)
        activitiyIndicator.startAnimating()
        activitiyIndicator.hidesWhenStopped = true
        
        return activitiyIndicator
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.isHidden = true
        
        return webView
    }()
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        
        // MARK: - Symbol Image
        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        
        // MARK: - Appearance
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .zero
        
        // MARK: - Interaction
        button.addTarget(self, action: #selector(openBookmarkForm(_:)), for: .touchUpInside)
        
        // MARK: - Style (iOS version specific)
        if #available(iOS 26.0, *) {
            button.tintColor = .accent2
            button.configuration = .prominentGlass()
        } else {
            button.tintColor = .white
            button.backgroundColor = .accent2
        }
        
        return button
    }()
    let viewModel: NoticeContentViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: NoticeContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLayout()
        setupNavigationBar()
        bind()
        view.backgroundColor = .detailViewBackground
        
        if let notice = viewModel.notice, let contentURL = URL(string: notice.contentUrl) {
            webView.load(URLRequest(url: contentURL))
        } else if let _ = viewModel.nttId {
            viewModel.fetch()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.setNavigationBarHidden(false, animated: true)    // iPadOS에서 네비게이션 바 표시
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.task?.cancel()
    }
    
    private func setupLayout() {
        //webView
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //bookmarkButton
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
    
    private func bind() {
        viewModel.$notice
            .dropFirst()
            .sink(receiveValue: { [weak self] notice in
                guard let notice, let url = URL(string: notice.contentUrl) else { return }
                
                self?.webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
            })
            .store(in: &cancellables)
    }
}

extension NoticeContentViewController: WKNavigationDelegate {
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

extension NoticeContentViewController {
    @objc func openBookmarkForm(_ sender: UIButton) {
        fatalError("openBookmarkForm(_:) must be overridden by subclass")
    }
}

extension NoticeContentViewController {
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
