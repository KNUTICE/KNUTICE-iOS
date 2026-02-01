//
//  NoticeWebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import ComposableArchitecture
import Combine
import KNDesignSystem
import KNIntelligence
import SwiftUI
import UIKit
import WebKit

public final class NoticeContentViewController: UIViewController {
    private let activityIndicator: UIActivityIndicatorView = {
        let activitiyIndicator = UIActivityIndicatorView(style: .large)
        activitiyIndicator.startAnimating()
        activitiyIndicator.hidesWhenStopped = true
        
        return activitiyIndicator
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.isHidden = true
        
        return webView
    }()
    private var buttonConfig: UIButton.Configuration {
        if #available(iOS 26, *) {
            return .glass()
        }
        
        return .filled()
    }
    private lazy var bookmarkButton: UIButton = {
        // 1. 스타일 설정
        var config = buttonConfig
        config.baseBackgroundColor = KNDesignSystemAsset.accent2.color
        config.cornerStyle = .capsule
        
        // 2. 이미지 설정
        config.image = KNDesignSystemAsset.knuticeaiLogo.image.resizedMaintainingAspectRatio(to: CGSize(width: 35, height: 35))
        
        // 3. 버튼 생성
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            guard let notice = self?.viewModel.notice else { return }
            
            let rootView = NoticeSummaryView(viewModel: NoticeSummaryViewModel(nttId: notice.id))
            let viewController = UIHostingController(rootView: rootView)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .pageSheet
            
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [
                    .medium(),   // 기본 중간 높이
                    .large()     // 사용자가 끝까지 확장 가능
                ]
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
            
            self?.present(navigationController, animated: true, completion: nil)
        })
        
        // 4. 그림자
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .zero
        
        return button
    }()
    let viewModel: NoticeContentViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    public init(viewModel: NoticeContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLayout()
        setupNavigationBar()
        bind()
        view.backgroundColor = KNDesignSystemAsset.detailViewBackground.color
        
        if let notice = viewModel.notice, let contentURL = URL(string: notice.contentUrl) {
            webView.load(URLRequest(url: contentURL))
        } else if let _ = viewModel.nttId {
            viewModel.fetch()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.setNavigationBarHidden(false, animated: true)    // iPadOS에서 네비게이션 바 표시
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.task?.cancel()
    }
    
    private func setupLayout() {
        //webView
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    private func setupNavigationBar() {
        // ActivityView Item
        let activityViewItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: UIAction { [weak self] _ in
                guard let notice = self?.viewModel.notice else { return }
                        
                let shareText = notice.contentUrl
                let shareObject = [shareText]
                let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self?.view
                activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                    if completed {
                        self?.showCompletionAlert()
                    }
                }
                
                self?.present(activityViewController, animated: true, completion: nil)
            }
        )
        
        // Bookmark Item
        let bookmarkItem = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            primaryAction: UIAction { [weak self] _ in
                guard let notice = self?.viewModel.notice else { return }
                
                let bookmark = Bookmark(notice: notice, memo: "")
                let rootView = BookmarkForm(
                    store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                        BookmarkFormFeature()
                    }
                ) {
                    self?.dismiss(animated: true)
                }
                let viewController = UIHostingController(rootView: rootView)
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .pageSheet
                
                self?.present(navigationController, animated: true, completion: nil)
            }
        )
            
        
        navigationItem.setRightBarButtonItems(
            [
                activityViewItem,
                bookmarkItem
            ],
            animated: true)
    }
    
    private func showCompletionAlert() {
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
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.isHidden = true
        
        let javaScriptString =
            """
            document.documentElement.style.webkitUserSelect='none';
            document.documentElement.style.webkitTouchCallout='none';
            
            if (document.getElementById("header")) document.getElementById("header").style.display='none';
            if (document.getElementById("footer")) document.getElementById("footer").style.display='none';
            if (document.getElementById("remote")) document.getElementById("remote").style.display='none';
            if (document.getElementById("foot_layout")) document.getElementById("foot_layout").style.display='none';
            if (document.getElementById("location")) document.getElementById("location").style.display='none';
            if (document.getElementById("snb")) document.getElementById("snb").style.display='none';
            if (document.getElementById("point")) document.getElementById("point").style.display='none';
            
            document.querySelectorAll(".board_butt").forEach(el => {
                el.style.display = 'none';
            });
            document.querySelectorAll(".layout h1").forEach(el => {
                if (el.textContent.includes("학사정보") || el.textContent.includes("커뮤니티")) {
                    el.style.display = "none";
                }
            });
            """
        webView.evaluateJavaScript(javaScriptString) { (res, error) -> Void in
            //로딩 완료 후 webView 활성화
            webView.isHidden = false
            
            if let error {
                print("WebViewController error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension NoticeContentViewController: WKUIDelegate {
    public func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if let aString = URL(string:(navigationAction.request.url?.absoluteString ?? "")) {
            UIApplication.shared.open(aString, options:[:]) { _ in }
        }
        
        return nil
    }
    
}
