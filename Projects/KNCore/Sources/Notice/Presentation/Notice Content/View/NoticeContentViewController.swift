//
//  NoticeContentViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import ComposableArchitecture
import Combine
import KNDesignSystem
import KNIntelligence
import KNUtility
import SnapKit
import SwiftUI
import UIKit
import WebKit

public final class NoticeContentViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
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
    
    private lazy var bookmarkButton: UIButton = {
        var config: UIButton.Configuration = {
            if #available(iOS 26, *) { return .glass() }
            return .filled()
        }()
        
        config.baseBackgroundColor = KNDesignSystemAsset.accent2.color
        config.cornerStyle = .capsule
        config.image = KNDesignSystemAsset.knuticeaiLogo.image
            .resizedMaintainingAspectRatio(to: CGSize(width: 35, height: 35))
        
        let action = UIAction { [weak self] _ in self?.presentSummarySheet() }
        let button = UIButton(configuration: config, primaryAction: action)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .zero
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: NoticeContentViewModel
    private var cancellables = Set<AnyCancellable>()
    private var abTestTask: Task<Void, Never>?
    
    @Published private var isWebPageLoaded = false
    @Published private var isABTestLoaded = false
    
    // MARK: - Init
    
    public init(viewModel: NoticeContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        loadInitialData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.task?.cancel()
        abTestTask?.cancel()
    }
}

// MARK: - Setup Methods

private extension NoticeContentViewController {
    func setupUI() {
        view.backgroundColor = KNDesignSystemAsset.detailViewBackground.color
        
        [webView, bookmarkButton, activityIndicator].forEach { view.addSubview($0) }
        
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
        bookmarkButton.snp.makeConstraints { make in
            let bottomOffset = UIDevice.current.userInterfaceIdiom == .phone ? -50 : -100
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let shareItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: UIAction { [weak self] _ in self?.presentShareSheet() }
        )
        
        let bookmarkItem = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            primaryAction: UIAction { [weak self] _ in self?.presentBookmarkForm() }
        )
        
        navigationItem.rightBarButtonItems = [shareItem, bookmarkItem]
    }
    
    func bind() {
        // 1. Notice URL 로딩 감시
        viewModel.$notice
            .compactMap { $0?.contentUrl }
            .compactMap { URL(string: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
            }
            .store(in: &cancellables)
        
        // 2. 최종 화면 노출 조건 결합
        Publishers.CombineLatest($isWebPageLoaded, $isABTestLoaded)
            .filter { $0 && $1 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.webView.isHidden = false
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    func loadInitialData() {
        fetchABTestConfig()
        
        if let urlString = viewModel.notice?.contentUrl, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else if viewModel.nttId != nil {
            viewModel.fetch()
        }
    }
    
    private func fetchABTestConfig() {
        abTestTask = Task {
            do {
                let _ = try await ABTestManager.shared.getString(key: ABTestKeys.bookmarkBtnType.rawValue)
                self.isABTestLoaded = true
            } catch {
                self.isABTestLoaded = true // 에러 발생 시에도 화면은 보여줌
            }
        }
    }
}

// MARK: - Presentation Actions

private extension NoticeContentViewController {
    private func presentSummarySheet() {
        guard let notice = viewModel.notice else { return }
        let summaryViewModel = NoticeSummaryViewModel(nttId: notice.id)
        let rootView = NoticeSummaryView(viewModel: summaryViewModel)
        presentSheet(rootView: rootView)
    }
    
    private func presentBookmarkForm() {
        guard let notice = viewModel.notice else { return }
        let bookmark = Bookmark(notice: notice, memo: "")
        let state = BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create)
        
        let rootView = BookmarkForm(
            store: Store(initialState: state) { BookmarkFormFeature() }
        ) { [weak self] in
            self?.dismiss(animated: true)
        }
        
        presentSheet(rootView: rootView)
    }
    
    private func presentSheet<Content: View>(rootView: Content) {
        let vc = UIHostingController(rootView: rootView)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
    
    private func presentShareSheet() {
        guard let urlStr = viewModel.notice?.contentUrl else { return }
        let activityVC = UIActivityViewController(activityItems: [urlStr], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.completionWithItemsHandler = { [weak self] _, completed, _, _ in
            if completed { self?.showCompletionAlert() }
        }
        present(activityVC, animated: true)
    }
    
    private func showCompletionAlert() {
        let alert = UIAlertController(title: "알림", message: "공유를 완료했어요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension NoticeContentViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(JavaScriptScripts.cleanUpKNUTPage) { [weak self] _, error in
            if let error = error { print("JS Error: \(error)") }
            self?.isWebPageLoaded = true
        }
    }
}

// MARK: - WKUIDelegate

extension NoticeContentViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = action.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
}

// MARK: - Constants

private enum JavaScriptScripts {
    static let cleanUpKNUTPage = """
    (function() {
        const hideIds = ['header', 'footer', 'remote', 'foot_layout', 'location', 'snb', 'point'];
        hideIds.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.style.display = 'none';
        });

        document.querySelectorAll(".board_butt").forEach(el => el.style.display = 'none');
        
        document.querySelectorAll(".layout h1").forEach(el => {
            const txt = el.textContent;
            if (txt.includes("학사정보") || txt.includes("커뮤니티")) {
                el.style.display = "none";
            }
        });

        document.documentElement.style.webkitUserSelect = 'none';
        document.documentElement.style.webkitTouchCallout = 'none';
    })();
    """
}
